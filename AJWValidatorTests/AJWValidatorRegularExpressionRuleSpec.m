#import "Kiwi.h"
#import "ALPValidator.h"

SPEC_BEGIN(ALPValidatorRegularExpressionRuleSpec)

describe(@"ALPValidatorRegularExpressionRule", ^{
    
    __block ALPValidator *stringValidator;
    __block ALPValidator *numericValidator;
    
    beforeEach(^{
        stringValidator = [ALPValidator validatorWithType:ALPValidatorTypeString];
        numericValidator = [ALPValidator validatorWithType:ALPValidatorTypeNumeric];
    });
    
    specify(^{
        [[theBlock(^{
            [numericValidator addValidationToEnsurePresenceWithInvalidMessage:nil];
        }) should] raise];
    });
        
    describe(@"Standard regular expression rule", ^{
        
        NSString *pattern = @"hello";
        NSString *invalid = @"hey";
        
        beforeEach(^{
            [stringValidator addValidationToEnsureRegularExpressionIsMetWithPattern:pattern invalidMessage:nil];
        });
        
        specify(^{
            [[theValue(stringValidator.ruleCount) should] equal:theValue(1)];
        });
        
        context(@"input does not satisfy the regular expression", ^{
            beforeEach(^{
                [stringValidator validate:invalid];
            });
            specify(^{
                [[theValue(stringValidator.state) should] equal:theValue(ALPValidatorValidationStateInvalid)];
            });
        });
        
        context(@"input satisfies the regular expression", ^{
            beforeEach(^{
                [stringValidator validate:pattern];
            });
            specify(^{
                [[theValue(stringValidator.state) should] equal:theValue(ALPValidatorValidationStateValid)];
            });
        });
        
    });
    
    describe(@"email rule", ^{
        
        NSArray *invalidEmailAddresses = @[@"user@invalid,com", @"userinvalid.com", @"invalid", @"user@invalid@example.com", @"user@in+valid.com"];
        NSString *validEmailAddress = @"user@valid.com";
                
        beforeEach(^{
            [stringValidator addValidationToEnsureValidEmailWithInvalidMessage:nil];
        });
        
        specify(^{
            [[theValue(stringValidator.ruleCount) should] equal:theValue(1)];
        });
        
        specify(^{
            [[theBlock(^{
                [numericValidator addValidationToEnsurePresenceWithInvalidMessage:nil];
            }) should] raise];
        });
        
        context(@"with invalid email addresses", ^{
            it(@"should be invalid", ^{
                [invalidEmailAddresses enumerateObjectsUsingBlock:^(NSString *invalidEmailAddress, NSUInteger idx, BOOL *stop) {
                    [stringValidator validate:invalidEmailAddress];
                    [[theValue(stringValidator.state) should] equal:theValue(ALPValidatorValidationStateInvalid)];
                }];
            });
        });
        
        context(@"with a valid email address", ^{
            beforeEach(^{
                [stringValidator validate:validEmailAddress];
            });
            specify(^{
                [[theValue(stringValidator.state) should] equal:theValue(ALPValidatorValidationStateValid)];
            });
        });
        
    });
    
    describe(@"string contains number rule", ^{
        
        beforeEach(^{
            [stringValidator addValidationToEnsureStringContainsNumberWithInvalidMessage:nil];
        });
        
        specify(^{
            [[theValue(stringValidator.ruleCount) should] equal:theValue(1)];
        });
        
        specify(^{
            [[theBlock(^{
                [numericValidator addValidationToEnsurePresenceWithInvalidMessage:nil];
            }) should] raise];
        });
        
        context(@"input does not contain a number", ^{
            beforeEach(^{
                [stringValidator validate:@"password"];
            });
            specify(^{
                [[theValue(stringValidator.state) should] equal:theValue(ALPValidatorValidationStateInvalid)];
            });
        });
        
        context(@"input contains a number", ^{
            beforeEach(^{
                [stringValidator validate:@"password1"];
            });
            specify(^{
                [[theValue(stringValidator.state) should] equal:theValue(ALPValidatorValidationStateValid)];
            });
        });
        
    });
    
    
});

SPEC_END
