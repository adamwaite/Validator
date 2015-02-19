#import "Kiwi.h"
#import "AJWValidator.h"

SPEC_BEGIN(AJWValidatorMinimumLengthRuleSpec)

describe(@"AJWValidatorMinimumLengthRule", ^{
    
    __block AJWValidator *stringValidator;
    __block AJWValidator *numericValidator;
    
    beforeEach(^{
        stringValidator = [AJWValidator validatorWithType:AJWValidatorTypeString];
        numericValidator = [AJWValidator validatorWithType:AJWValidatorTypeNumeric];
        [stringValidator addValidationToEnsureMinimumLength:3 invalidMessage:nil];
    });
    
    specify(^{
        [[theValue(stringValidator.ruleCount) should] equal:theValue(1)];
    });
    
    specify(^{
        [[theBlock(^{
            [numericValidator addValidationToEnsurePresenceWithInvalidMessage:nil];
        }) should] raise];
    });
    
    context(@"failing to satisfy the minimum length condition", ^{
        beforeEach(^{
            [stringValidator validate:@"ab"];
        });
        specify(^{
            [[theValue(stringValidator.state) should] equal:theValue(AJWValidatorValidationStateInvalid)];
        });
    });
    
    context(@"satisfying the minimum length condition", ^{
        beforeEach(^{
            [stringValidator validate:@"abcd"];
        });
        specify(^{
            [[theValue(stringValidator.state) should] equal:theValue(AJWValidatorValidationStateValid)];
        });
    });
    
});

SPEC_END
