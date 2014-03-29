#import "Kiwi.h"
#import "ALPValidator.h"

SPEC_BEGIN(ALPValidatorMinimumLengthRuleSpec)

describe(@"ALPValidatorMinimumLengthRule", ^{
    
    __block ALPValidator *stringValidator;
    __block ALPValidator *numericValidator;
    
    beforeEach(^{
        stringValidator = [ALPValidator validatorWithType:ALPValidatorTypeString];
        numericValidator = [ALPValidator validatorWithType:ALPValidatorTypeNumeric];
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
            [[theValue(stringValidator.state) should] equal:theValue(ALPValidatorValidationStateInvalid)];
        });
    });
    
    context(@"satisfying the minimum length condition", ^{
        beforeEach(^{
            [stringValidator validate:@"abcd"];
        });
        specify(^{
            [[theValue(stringValidator.state) should] equal:theValue(ALPValidatorValidationStateValid)];
        });
    });
    
});

SPEC_END
