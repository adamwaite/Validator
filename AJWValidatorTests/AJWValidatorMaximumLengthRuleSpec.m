#import "Kiwi.h"
#import "ALPValidator.h"

SPEC_BEGIN(ALPValidatorMaximumLengthRuleSpec)

describe(@"ALPValidatorMaximumLengthRule", ^{
    
    __block ALPValidator *stringValidator;
    __block ALPValidator *numericValidator;
    
    beforeEach(^{
        stringValidator = [ALPValidator validatorWithType:ALPValidatorTypeString];
        numericValidator = [ALPValidator validatorWithType:ALPValidatorTypeNumeric];
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
            [[theValue(stringValidator.state) should] equal:theValue(ALPValidatorValidationStateInvalid)];
        });
    });
    
    context(@"satisfying the maximum length condition", ^{
        beforeEach(^{
            [stringValidator validate:@"abc"];
        });
        specify(^{
            [[theValue(stringValidator.state) should] equal:theValue(ALPValidatorValidationStateValid)];
        });
    });
    
});

SPEC_END
