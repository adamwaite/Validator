#import "Kiwi.h"
#import "ALPValidator.h"

SPEC_BEGIN(ALPValidatorSpec)

describe(@"ALPValidator", ^{

    #pragma mark Initialiser Specs
    
    describe(@"initialiser", ^{
        
        __block id subject;
        
        context(@"not using the designated initialiser", ^{
            specify(^{
                [[theBlock(^{ subject = [[ALPValidator alloc] init]; }) should] raise];
            });
        });
        
        context(@"using the designated initialiser", ^{
            beforeEach(^{
                subject = [ALPValidator validatorWithType:ALPValidatorTypeString];
            });
            specify(^{
                [[subject should] beKindOfClass:[ALPValidator class]];
            });
        });
        
    });
    
    describe(@"multiple validations", ^{
        
        __block ALPValidator *subject;
        
        beforeEach(^{
            subject = [ALPValidator validatorWithType:ALPValidatorTypeString];
            [subject addValidationToEnsureMinimumLength:5 invalidMessage:nil];
            [subject addValidationToEnsureValidEmailWithInvalidMessage:nil];
            [subject addValidationToEnsureCustomConditionIsSatisfiedWithBlock:^BOOL(NSString *instance) {
                return ([instance rangeOfString:@"A"].location == NSNotFound);
            } invalidMessage:nil];
        });
        
        afterEach(^{
            subject = nil;
        });
        
        specify(^{
            [[theValue(subject.ruleCount) should] equal:theValue(3)];
        });
        
        context(@"invalid", ^{
            beforeEach(^{
                [subject validate:@"hAhA"];
            });
            specify(^{
                [[theValue(subject.state) should] equal:theValue(ALPValidatorValidationStateInvalid)];
            });
            specify(^{
                [[theValue([subject.errorMessages count]) should] equal:theValue(3)];
            });
        });
        
        context(@"failing just one condition", ^{
            beforeEach(^{
                [subject validate:@"Almostvalid@string.com"];
            });
            specify(^{
                [[theValue(subject.state) should] equal:theValue(ALPValidatorValidationStateInvalid)];
            });
            specify(^{
                [[theValue([subject.errorMessages count]) should] equal:theValue(1)];
            });
        });
        
        context(@"valid", ^{
            beforeEach(^{
                [subject validate:@"valid@string.com"];
            });
            specify(^{
                [[theValue(subject.state) should] equal:theValue(ALPValidatorValidationStateValid)];
            });
            specify(^{
                [[theValue([subject.errorMessages count]) should] equal:theValue(0)];
            });
        });
        
    });
    
    describe(@"messages", ^{
        
        __block ALPValidator *subject;
        
        beforeEach(^{
            subject = [ALPValidator validatorWithType:ALPValidatorTypeString];
        });
        
        afterEach(^{
            subject = nil;
        });
        
        context(@"when valid", ^{
            
            context(@"no rules", ^{
                specify(^{
                    [[theValue([subject.errorMessages count]) should] equal:theValue(0)];
                });
            });
            
            context(@"with a satisfied rule", ^{
                beforeEach(^{
                    [subject addValidationToEnsureMinimumLength:4 invalidMessage:@"string not long enough"];
                    [subject validate:@"abcde"];
                });
                specify(^{
                    [[theValue([subject.errorMessages count]) should] equal:theValue(0)];
                });
            });
            
        });
        
        context(@"when invalid", ^{
            
            context(@"default messages (nil passed with rule)", ^{
                beforeEach(^{
                    [subject addValidationToEnsureMinimumLength:4 invalidMessage:nil];
                    [subject validate:@"abc"];
                });
                specify(^{
                    [[theValue([subject.errorMessages count]) should] equal:theValue(1)];
                });
            });

            context(@"rule supplied with validation add", ^{
                NSString *errorMessage = @"that's not an email address, silly user";
                beforeEach(^{
                    [subject addValidationToEnsureValidEmailWithInvalidMessage:errorMessage];
                    [subject validate:@"inv@lid,co,uk"];
                });
                specify(^{
                    [[theValue([subject.errorMessages count]) should] equal:theValue(1)];
                });
                specify(^{
                    [[[subject.errorMessages lastObject] should] equal:errorMessage];
                });
            });
            
            describe(@"errors clear when changed", ^{
                beforeEach(^{
                    [subject addValidationToEnsureValidEmailWithInvalidMessage:nil];
                    [subject validate:@"inv@lid,co,uk"];
                    [subject validate:@"inv@lid.co.uk"];
                });
                specify(^{
                    [[theValue([subject.errorMessages count]) should] equal:theValue(0)];
                });
            });
            
        });
        
    });
    
    #pragma mark State Change Handler Specs
    
    describe(@"state change handler", ^{
        
        __block ALPValidator *subject;
        __block NSUInteger thingToWatch = 0;
        
        beforeEach(^{
            subject = [ALPValidator validatorWithType:ALPValidatorTypeString];
            [subject addValidationToEnsurePresenceWithInvalidMessage:nil];
            subject.validatorStateChangedHandler = ^(ALPValidatorState newState) {
                if (newState == ALPValidatorValidationStateValid) {
                    thingToWatch++;
                }
            };
            [subject validate:@"valid"];
        });
        
        afterEach(^{
            subject = nil;
        });
        
        specify(^{
            [[theValue(thingToWatch) should] equal:theValue(1)];
        });
        
    });
    
    #pragma mark UIControl+ALPValidator
    
    
    
});

SPEC_END
