#import <Cedar/SpecHelper.h>
#import "SimpleIncrementer.h"

extern "C" {
#import "ExpectFailureWithMessage.h"
}

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(HaveReceivedSpec)

describe(@"have_received matcher", ^{
    __block SimpleIncrementer *incrementer;

    beforeEach(^{
        incrementer = [[[SimpleIncrementer alloc] init] autorelease];
        spy_on(incrementer);
    });

    context(@"with an actual value that is not a spy", ^{
        beforeEach(^{
            incrementer = [[[SimpleIncrementer alloc] init] autorelease];
        });

        it(@"should raise a descriptive exception", ^{
            expectFailureWithMessage([NSString stringWithFormat:@"Received expectation for non-double object <%@>", incrementer], ^{
                [incrementer increment];
                incrementer should have_received("increment");
            });
        });
    });

    context(@"for a method with no parameters", ^{
        SEL method = @selector(increment);

        context(@"which has been called", ^{
            beforeEach(^{
                [incrementer increment];
            });

            describe(@"positive match", ^{
                it(@"should pass", ^{
                    expect(incrementer).to(have_received(method));
                    expect(incrementer).to(have_received("increment"));
                });
            });

            describe(@"negative match", ^{
                it(@"should fail with a sensible failure message", ^{
                    expectFailureWithMessage([NSString stringWithFormat:@"Expected <%@> to not have received message <%@>", incrementer, NSStringFromSelector(method)], ^{
                        expect(incrementer).to_not(have_received(method));
                    });

                    expectFailureWithMessage([NSString stringWithFormat:@"Expected <%@> to not have received message <%@>", incrementer, NSStringFromSelector(method)], ^{
                        expect(incrementer).to_not(have_received("increment"));
                    });
                });
            });
        });

        context(@"which has not been called", ^{
            describe(@"positive match", ^{
                it(@"should fail with a sensible failure message", ^{
                    expectFailureWithMessage([NSString stringWithFormat:@"Expected <%@> to have received message <%@>", incrementer, NSStringFromSelector(method)], ^{
                        expect(incrementer).to(have_received(method));
                    });

                    expectFailureWithMessage([NSString stringWithFormat:@"Expected <%@> to have received message <%@>", incrementer, NSStringFromSelector(method)], ^{
                        expect(incrementer).to(have_received("increment"));
                    });
                });
            });

            describe(@"negative match", ^{
                it(@"should pass", ^{
                    expect(incrementer).to_not(have_received(method));
                    expect(incrementer).to_not(have_received("increment"));
                });
            });
        });
    });

    context(@"for a method with a non-object parameter", ^{
        SEL method = @selector(incrementBy:);

        context(@"which has been called", ^{
            int actualParameter = 2;

            beforeEach(^{
                [incrementer incrementBy:actualParameter];
            });

            context(@"with no parameter expectations", ^{
                describe(@"positive match", ^{
                    it(@"should pass", ^{
                        expect(incrementer).to(have_received(method));
                        expect(incrementer).to(have_received("incrementBy:"));
                    });
                });

                describe(@"negative match", ^{
                    it(@"should fail with a sensible failure message", ^{
                        expectFailureWithMessage([NSString stringWithFormat:@"Expected <%@> to not have received message <%@>", incrementer, NSStringFromSelector(method)], ^{
                            expect(incrementer).to_not(have_received(method));
                        });

                        expectFailureWithMessage([NSString stringWithFormat:@"Expected <%@> to not have received message <%@>", incrementer, NSStringFromSelector(method)], ^{
                            expect(incrementer).to_not(have_received("incrementBy:"));
                        });
                    });
                });
            });

            context(@"with the correct expected parameter", ^{
                unsigned short expectedParameter = actualParameter;

                describe(@"positive match", ^{
                    it(@"should pass", ^{
                        expect(incrementer).to(have_received(method).with(expectedParameter));
                        expect(incrementer).to(have_received("incrementBy:").with(expectedParameter));
                    });
                });

                describe(@"negative match", ^{
                    it(@"should fail with a sensible failure message", ^{
                        expectFailureWithMessage([NSString stringWithFormat:@"Expected <%@> to not have received message <%@>, with arguments: <%d>", incrementer, NSStringFromSelector(method), expectedParameter], ^{
                            expect(incrementer).to_not(have_received(method).with(expectedParameter));
                        });

                        expectFailureWithMessage([NSString stringWithFormat:@"Expected <%@> to not have received message <%@>, with arguments: <%d>", incrementer, NSStringFromSelector(method), expectedParameter], ^{
                            expect(incrementer).to_not(have_received("incrementBy:").with(expectedParameter));
                        });
                    });
                });
            });

            context(@"with an incorrect expected parameter", ^{
                unsigned short expectedParameter = actualParameter + 1;

                describe(@"positive match", ^{
                    it(@"should fail with a sensible failure message", ^{
                        expectFailureWithMessage([NSString stringWithFormat:@"Expected <%@> to have received message <%@>, with arguments: <%d>", incrementer, NSStringFromSelector(method), expectedParameter], ^{
                            expect(incrementer).to(have_received(method).with(expectedParameter));
                        });

                        expectFailureWithMessage([NSString stringWithFormat:@"Expected <%@> to have received message <%@>, with arguments: <%d>", incrementer, NSStringFromSelector(method), expectedParameter], ^{
                            expect(incrementer).to(have_received("incrementBy:").with(expectedParameter));
                        });
                    });
                });

                describe(@"negative match", ^{
                    it(@"should pass", ^{
                        expect(incrementer).to_not(have_received(method).with(expectedParameter));
                        expect(incrementer).to_not(have_received("incrementBy:").with(expectedParameter));
                    });
                });
            });
        });

        context(@"which has not been called", ^{
            long expectedParameter = 3;

            describe(@"positive match", ^{
                it(@"should fail with a sensible failure message", ^{
                    expectFailureWithMessage([NSString stringWithFormat:@"Expected <%@> to have received message <%@>, with arguments: <%d>", incrementer, NSStringFromSelector(method), expectedParameter], ^{
                        expect(incrementer).to(have_received(method).with(expectedParameter));
                    });

                    expectFailureWithMessage([NSString stringWithFormat:@"Expected <%@> to have received message <%@>, with arguments: <%d>", incrementer, NSStringFromSelector(method), expectedParameter], ^{
                        expect(incrementer).to(have_received("incrementBy:").with(expectedParameter));
                    });
                });
            });

            describe(@"negative match", ^{
                it(@"should pass", ^{
                    expect(incrementer).to_not(have_received(method).with(expectedParameter));
                    expect(incrementer).to_not(have_received("incrementBy:").with(expectedParameter));
                });
            });
        });
    });

    context(@"for a method with an object parameter", ^{
        SEL method = @selector(incrementByNumber:);
        id actualParameter = [NSNumber numberWithInt:3];

        context(@"which has been called", ^{
            beforeEach(^{
                [incrementer incrementByNumber:actualParameter];
            });

            context(@"with no parameter expectations", ^{
                describe(@"positive match", ^{
                    it(@"should pass", ^{
                        expect(incrementer).to(have_received(method));
                        expect(incrementer).to(have_received("incrementByNumber:"));
                    });
                });

                describe(@"negative match", ^{
                    it(@"should fail with a sensible failure message", ^{
                        expectFailureWithMessage([NSString stringWithFormat:@"Expected <%@> to not have received message <%@>", incrementer, NSStringFromSelector(method)], ^{
                            expect(incrementer).to_not(have_received(method));
                        });

                        expectFailureWithMessage([NSString stringWithFormat:@"Expected <%@> to not have received message <%@>", incrementer, NSStringFromSelector(method)], ^{
                            expect(incrementer).to_not(have_received("incrementByNumber:"));
                        });
                    });
                });
            });

            context(@"with the correct expected parameter", ^{
                NSNumber *expectedParameter = [NSNumber numberWithFloat:[actualParameter intValue]];

                describe(@"positive match", ^{
                    it(@"should pass", ^{
                        expect(incrementer).to(have_received(method).with(expectedParameter));
                        expect(incrementer).to(have_received("incrementByNumber:").with(expectedParameter));
                    });
                });

                describe(@"negative match", ^{
                    it(@"should fail with a sensible failure message", ^{
                        expectFailureWithMessage([NSString stringWithFormat:@"Expected <%@> to not have received message <%@>, with arguments: <%@>", incrementer, NSStringFromSelector(method), expectedParameter], ^{
                            expect(incrementer).to_not(have_received(method).with(expectedParameter));
                        });

                        expectFailureWithMessage([NSString stringWithFormat:@"Expected <%@> to not have received message <%@>, with arguments: <%@>", incrementer, NSStringFromSelector(method), expectedParameter], ^{
                            expect(incrementer).to_not(have_received("incrementByNumber:").with(expectedParameter));
                        });
                    });
                });
            });

            context(@"with an incorrect expected parameter", ^{
                NSNumber *expectedParameter = [NSNumber numberWithFloat:[actualParameter floatValue] + 0.5];

                describe(@"positive match", ^{
                    it(@"should fail with a sensible failure message", ^{
                        expectFailureWithMessage([NSString stringWithFormat:@"Expected <%@> to have received message <%@>, with arguments: <%@>", incrementer, NSStringFromSelector(method), expectedParameter], ^{
                            expect(incrementer).to(have_received(method).with(expectedParameter));
                        });

                        expectFailureWithMessage([NSString stringWithFormat:@"Expected <%@> to have received message <%@>, with arguments: <%@>", incrementer, NSStringFromSelector(method), expectedParameter], ^{
                            expect(incrementer).to(have_received("incrementByNumber:").with(expectedParameter));
                        });
                    });
                });

                describe(@"negative match", ^{
                    it(@"should pass", ^{
                        expect(incrementer).to_not(have_received(method).with(expectedParameter));
                        expect(incrementer).to_not(have_received("incrementByNumber:").with(expectedParameter));
                    });
                });
            });
        });

        context(@"which has not been called", ^{
            NSNumber *expectedParameter = [NSNumber numberWithInt:2];

            describe(@"positive match", ^{
                it(@"should fail with a sensible failure message", ^{
                    expectFailureWithMessage([NSString stringWithFormat:@"Expected <%@> to have received message <%@>, with arguments: <%@>", incrementer, NSStringFromSelector(method), expectedParameter], ^{
                        expect(incrementer).to(have_received(method).with(expectedParameter));
                    });

                    expectFailureWithMessage([NSString stringWithFormat:@"Expected <%@> to have received message <%@>, with arguments: <%@>", incrementer, NSStringFromSelector(method), expectedParameter], ^{
                        expect(incrementer).to(have_received("incrementByNumber:").with(expectedParameter));
                    });
                });
            });

            describe(@"negative match", ^{
                it(@"should pass", ^{
                    expect(incrementer).to_not(have_received(method).with(expectedParameter));
                    expect(incrementer).to_not(have_received("incrementBy:").with(expectedParameter));
                });
            });
        });
    });

    context(@"for a method with multiple parameters, some object, some not", ^{
        SEL method = @selector(incrementByABit:andABitMore:);
        int actualFirstParameter = 83;
        id actualSecondParameter = [NSNumber numberWithInt:32];

        context(@"which has been called", ^{
            beforeEach(^{
                [incrementer incrementByABit:actualFirstParameter andABitMore:actualSecondParameter];
            });

            context(@"with the correct expected parameter", ^{
                unsigned long long expectedFirstParameter = actualFirstParameter;
                NSObject * expectedSecondParameter = [NSNumber numberWithFloat:[actualSecondParameter floatValue]];

                describe(@"positive match", ^{
                    it(@"should pass", ^{
                        expect(incrementer).to(have_received(method).with(expectedFirstParameter).and_with(expectedSecondParameter));
                        expect(incrementer).to(have_received("incrementByABit:andABitMore:").with(expectedFirstParameter).and_with(expectedSecondParameter));
                    });
                });

                describe(@"negative match", ^{
                    it(@"should fail with a sensible failure message", ^{
                        expectFailureWithMessage([NSString stringWithFormat:@"Expected <%@> to not have received message <%@>, with arguments: <%d, %@>", incrementer, NSStringFromSelector(method), expectedFirstParameter, expectedSecondParameter], ^{
                            expect(incrementer).to_not(have_received(method).with(expectedFirstParameter).and_with(expectedSecondParameter));
                        });

                        expectFailureWithMessage([NSString stringWithFormat:@"Expected <%@> to not have received message <%@>, with arguments: <%d, %@>", incrementer, NSStringFromSelector(method), expectedFirstParameter, expectedSecondParameter], ^{
                            expect(incrementer).to_not(have_received("incrementByABit:andABitMore:").with(expectedFirstParameter).and_with(expectedSecondParameter));
                        });
                    });
                });
            });

            context(@"with fewer expected parameters than actual parameters", ^{
                long long expectedFirstParameter = actualFirstParameter;

                describe(@"positive match", ^{
                    it(@"should fail with a sensible failure message", ^{
                        expectFailureWithMessage([NSString stringWithFormat:@"Too few parameters expected for message <%@>; required 2, expected 1", NSStringFromSelector(method)], ^{
                            expect(incrementer).to(have_received(method).with(expectedFirstParameter));
                        });

                        expectFailureWithMessage([NSString stringWithFormat:@"Too few parameters expected for message <%@>; required 2, expected 1", NSStringFromSelector(method)], ^{
                            expect(incrementer).to(have_received("incrementByABit:andABitMore:").with(expectedFirstParameter));
                        });
                    });
                });

                describe(@"negative match", ^{
                    it(@"should fail with a sensible failure message", ^{
                        expectFailureWithMessage([NSString stringWithFormat:@"Too few parameters expected for message <%@>; required 2, expected 1", NSStringFromSelector(method)], ^{
                            expect(incrementer).to_not(have_received(method).with(expectedFirstParameter));
                        });

                        expectFailureWithMessage([NSString stringWithFormat:@"Too few parameters expected for message <%@>; required 2, expected 1", NSStringFromSelector(method)], ^{
                            expect(incrementer).to_not(have_received("incrementByABit:andABitMore:").with(expectedFirstParameter));
                        });
                    });
                });
            });

            context(@"with more expected parameters than actual parameters", ^{
                long long expectedFirstParameter = actualFirstParameter;
                id expectedSecondParameter = @"second", expectedThirdParameter = @"third";

                describe(@"positive match", ^{
                    it(@"should fail with a sensible failure message", ^{
                        expectFailureWithMessage([NSString stringWithFormat:@"Too many parameters expected for message <%@>; required 2, expected 3", NSStringFromSelector(method)], ^{
                            expect(incrementer).to(have_received(method).with(expectedFirstParameter).with(expectedSecondParameter).and_with(expectedThirdParameter));
                        });

                        expectFailureWithMessage([NSString stringWithFormat:@"Too many parameters expected for message <%@>; required 2, expected 3", NSStringFromSelector(method)], ^{
                            expect(incrementer).to(have_received("incrementByABit:andABitMore:").with(expectedFirstParameter).with(expectedSecondParameter).and_with(expectedThirdParameter));
                        });
                    });
                });

                describe(@"negative match", ^{
                    it(@"should fail with a sensible failure message", ^{
                        expectFailureWithMessage([NSString stringWithFormat:@"Too many parameters expected for message <%@>; required 2, expected 3", NSStringFromSelector(method)], ^{
                            expect(incrementer).to_not(have_received(method).with(expectedFirstParameter).with(expectedSecondParameter).and_with(expectedThirdParameter));
                        });

                        expectFailureWithMessage([NSString stringWithFormat:@"Too many parameters expected for message <%@>; required 2, expected 3", NSStringFromSelector(method)], ^{
                            expect(incrementer).to_not(have_received("incrementByABit:andABitMore:").with(expectedFirstParameter).with(expectedSecondParameter).and_with(expectedThirdParameter));
                        });
                    });
                });
            });

            context(@"with an incorrect parameter expectation", ^{
                unsigned long long expectedFirstParameter = actualFirstParameter;
                NSObject * expectedSecondParameter = [NSNumber numberWithFloat:[actualSecondParameter floatValue] + 0.6];

                describe(@"positive match", ^{
                    it(@"should fail with a sensible failure message", ^{
                        expectFailureWithMessage([NSString stringWithFormat:@"Expected <%@> to have received message <%@>, with arguments: <%d, %@>", incrementer, NSStringFromSelector(method), expectedFirstParameter, expectedSecondParameter], ^{
                            expect(incrementer).to(have_received(method).with(expectedFirstParameter).and_with(expectedSecondParameter));
                        });

                        expectFailureWithMessage([NSString stringWithFormat:@"Expected <%@> to have received message <%@>, with arguments: <%d, %@>", incrementer, NSStringFromSelector(method), expectedFirstParameter, expectedSecondParameter], ^{
                            expect(incrementer).to(have_received("incrementByABit:andABitMore:").with(expectedFirstParameter).and_with(expectedSecondParameter));
                        });
                    });
                });

                describe(@"negative match", ^{
                    it(@"should pass", ^{
                        expect(incrementer).to_not(have_received(method).with(expectedFirstParameter).and_with(expectedSecondParameter));
                        expect(incrementer).to_not(have_received("incrementByABit:andABitMore:").with(expectedFirstParameter).and_with(expectedSecondParameter));
                    });
                });
            });
        });

        context(@"which has not been called", ^{
            describe(@"positive match", ^{
                it(@"should fail with a sensible failure message", ^{
                    expectFailureWithMessage([NSString stringWithFormat:@"Expected <%@> to have received message <%@>", incrementer, NSStringFromSelector(method)], ^{
                        expect(incrementer).to(have_received(method));
                    });

                    expectFailureWithMessage([NSString stringWithFormat:@"Expected <%@> to have received message <%@>", incrementer, NSStringFromSelector(method)], ^{
                        expect(incrementer).to(have_received("incrementByABit:andABitMore:"));
                    });
                });
            });

            describe(@"negative match", ^{
                it(@"should pass", ^{
                    expect(incrementer).to_not(have_received(method));
                    expect(incrementer).to_not(have_received("incrementByABit:andABitMore:"));
                });
            });
        });
    });

    context(@"for a method that throws an exception", ^{
        it(@"should continue to record methods correctly", ^{
            @try {
                [incrementer incrementWithException];
            } @catch (NSException * ) {

            }
            [incrementer increment];

            incrementer should have_received("increment");
        });
    });
});

SPEC_END
