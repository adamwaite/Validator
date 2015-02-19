#import "Kiwi.h"
#import "AJWValidator.h"

SPEC_BEGIN(AJWValidatorRegularExpressionRuleSpec)

describe(@"AJWValidatorRegularExpressionRule", ^{
    
    __block AJWValidator *stringValidator;
    __block AJWValidator *numericValidator;
    
    beforeEach(^{
        stringValidator = [AJWValidator validatorWithType:AJWValidatorTypeString];
        numericValidator = [AJWValidator validatorWithType:AJWValidatorTypeNumeric];
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
                [[theValue(stringValidator.state) should] equal:theValue(AJWValidatorValidationStateInvalid)];
            });
        });
        
        context(@"input satisfies the regular expression", ^{
            beforeEach(^{
                [stringValidator validate:pattern];
            });
            specify(^{
                [[theValue(stringValidator.state) should] equal:theValue(AJWValidatorValidationStateValid)];
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
                    [[theValue(stringValidator.state) should] equal:theValue(AJWValidatorValidationStateInvalid)];
                }];
            });
        });
        
        context(@"with a valid email address", ^{
            beforeEach(^{
                [stringValidator validate:validEmailAddress];
            });
            specify(^{
                [[theValue(stringValidator.state) should] equal:theValue(AJWValidatorValidationStateValid)];
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
                [[theValue(stringValidator.state) should] equal:theValue(AJWValidatorValidationStateInvalid)];
            });
        });
        
        context(@"input contains a number", ^{
            beforeEach(^{
                [stringValidator validate:@"password1"];
            });
            specify(^{
                [[theValue(stringValidator.state) should] equal:theValue(AJWValidatorValidationStateValid)];
            });
        });
        
    });
    
    
});

SPEC_END
