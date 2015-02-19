#import "Kiwi.h"
#import "AJWValidator.h"

SPEC_BEGIN(AJWValidatorRangeRuleSpec)

describe(@"AJWValidatorRangeRule", ^{
    
    __block AJWValidator *stringValidator;
    __block AJWValidator *numericValidator;
    
    beforeEach(^{
        stringValidator = [AJWValidator validatorWithType:AJWValidatorTypeString];
        numericValidator = [AJWValidator validatorWithType:AJWValidatorTypeNumeric];

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
            [[theValue(stringValidator.state) should] equal:theValue(AJWValidatorValidationStateInvalid)];
        });
    });
    
    context(@"string that is too long", ^{
        beforeEach(^{
            [stringValidator validate:@"abcdefghijklmnop"];
        });
        specify(^{
            [[theValue(stringValidator.state) should] equal:theValue(AJWValidatorValidationStateInvalid)];
        });
    });
    
    context(@"string that is within the character range", ^{
        beforeEach(^{
            [stringValidator validate:@"abcde"];
        });
        specify(^{
            [[theValue(stringValidator.state) should] equal:theValue(AJWValidatorValidationStateValid)];
        });
    });
    
    context(@"number that is too small", ^{
        beforeEach(^{
            [numericValidator validate:@2.999];
        });
        specify(^{
            [[theValue(numericValidator.state) should] equal:theValue(AJWValidatorValidationStateInvalid)];
        });
    });
    
    context(@"number that is too big", ^{
        beforeEach(^{
            [numericValidator validate:@10.001];
        });
        specify(^{
            [[theValue(numericValidator.state) should] equal:theValue(AJWValidatorValidationStateInvalid)];
        });
    });
    
    context(@"number that is within range", ^{
        beforeEach(^{
            [numericValidator validate:@5];
        });
        specify(^{
            [[theValue(numericValidator.state) should] equal:theValue(AJWValidatorValidationStateValid)];
        });
    });
    
});

SPEC_END
