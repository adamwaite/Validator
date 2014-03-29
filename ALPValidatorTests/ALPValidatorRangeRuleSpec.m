#import "Kiwi.h"
#import "ALPValidator.h"

SPEC_BEGIN(ALPValidatorRangeRuleSpec)

describe(@"ALPValidatorRangeRule", ^{
    
    __block ALPValidator *stringValidator;
    __block ALPValidator *numericValidator;
    
    beforeEach(^{
        stringValidator = [ALPValidator validatorWithType:ALPValidatorTypeString];
        numericValidator = [ALPValidator validatorWithType:ALPValidatorTypeNumeric];

        [stringValidator addValidationToEnsureRangeWithMinimum:@3 maximum:@10 invalidMessage:nil];
        [numericValidator addValidationToEnsureRangeWithMinimum:@3 maximum:@10 invalidMessage:nil];
    });
    
    specify(^{
        [[theValue(stringValidator.ruleCount) should] equal:theValue(1)];
    });
    
    specify(^{
        [[theValue(numericValidator.ruleCount) should] equal:theValue(1)];
    });
    
    context(@"string that is too short", ^{
        beforeEach(^{
            [stringValidator validate:@"ab"];
        });
        specify(^{
            [[theValue(stringValidator.state) should] equal:theValue(ALPValidatorValidationStateInvalid)];
        });
    });
    
    context(@"string that is too long", ^{
        beforeEach(^{
            [stringValidator validate:@"abcdefghijklmnop"];
        });
        specify(^{
            [[theValue(stringValidator.state) should] equal:theValue(ALPValidatorValidationStateInvalid)];
        });
    });
    
    context(@"string that is within the character range", ^{
        beforeEach(^{
            [stringValidator validate:@"abcde"];
        });
        specify(^{
            [[theValue(stringValidator.state) should] equal:theValue(ALPValidatorValidationStateValid)];
        });
    });
    
    context(@"number that is too small", ^{
        beforeEach(^{
            [numericValidator validate:@2.999];
        });
        specify(^{
            [[theValue(numericValidator.state) should] equal:theValue(ALPValidatorValidationStateInvalid)];
        });
    });
    
    context(@"number that is too big", ^{
        beforeEach(^{
            [numericValidator validate:@10.001];
        });
        specify(^{
            [[theValue(numericValidator.state) should] equal:theValue(ALPValidatorValidationStateInvalid)];
        });
    });
    
    context(@"number that is within range", ^{
        beforeEach(^{
            [numericValidator validate:@5];
        });
        specify(^{
            [[theValue(numericValidator.state) should] equal:theValue(ALPValidatorValidationStateValid)];
        });
    });
    
});

SPEC_END
