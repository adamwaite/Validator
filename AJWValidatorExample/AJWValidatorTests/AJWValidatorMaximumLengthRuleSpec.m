#import "Kiwi.h"
#import "AJWValidator.h"

SPEC_BEGIN(AJWValidatorMaximumLengthRuleSpec)

describe(@"AJWValidatorMaximumLengthRule", ^{
    
    __block AJWValidator *stringValidator;
    __block AJWValidator *numericValidator;
    
    beforeEach(^{
        stringValidator = [AJWValidator validatorWithType:AJWValidatorTypeString];
        numericValidator = [AJWValidator validatorWithType:AJWValidatorTypeNumeric];
        [stringValidator addValidationToEnsureMaximumLength:5 invalidMessage:nil];
    });
    
    specify(^{
        [[theValue(stringValidator.ruleCount) should] equal:theValue(1)];
    });
    
    specify(^{
        [[theBlock(^{
            [numericValidator addValidationToEnsurePresenceWithInvalidMessage:nil];
        }) should] raise];
    });
    
    context(@"exceeding the maximum length condition", ^{
        beforeEach(^{
            [stringValidator validate:@"abcdef"];
        });
        specify(^{
            [[theValue(stringValidator.state) should] equal:theValue(AJWValidatorValidationStateInvalid)];
        });
    });
    
    context(@"satisfying the maximum length condition", ^{
        beforeEach(^{
            [stringValidator validate:@"abc"];
        });
        specify(^{
            [[theValue(stringValidator.state) should] equal:theValue(AJWValidatorValidationStateValid)];
        });
    });
    
});

SPEC_END
