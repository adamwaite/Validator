#import "Kiwi.h"
#import "AJWValidator.h"

SPEC_BEGIN(AJWValidatorCustomRuleSpec)

describe(@"AJWValidatorCustomRule", ^{
    
    AJWValidatorCustomRuleBlock noLetterACustomRule = ^BOOL(NSString *instance){
        return ([instance rangeOfString:@"A"].location == NSNotFound);
    };
    
    AJWValidatorCustomRuleBlock numberIsFive = ^BOOL(NSNumber *instance){
        return ([instance isEqual:@5]);
    };
    
    __block AJWValidator *stringValidator;
    __block AJWValidator *numericValidator;
    
    beforeEach(^{
        stringValidator = [AJWValidator validatorWithType:AJWValidatorTypeString];
        numericValidator = [AJWValidator validatorWithType:AJWValidatorTypeNumeric];
        [stringValidator addValidationToEnsureCustomConditionIsSatisfiedWithBlock:noLetterACustomRule invalidMessage:nil];
        [numericValidator addValidationToEnsureCustomConditionIsSatisfiedWithBlock:numberIsFive invalidMessage:nil];
    });
    
    specify(^{
        [[theValue(stringValidator.ruleCount) should] equal:theValue(1)];
    });
    
    specify(^{
        [[theValue(numericValidator.ruleCount) should] equal:theValue(1)];
    });
    
    context(@"custom condition is not satisfied", ^{
        beforeEach(^{
            [stringValidator validate:@"hAllo"];
            [numericValidator validate:@1];
        });
        specify(^{
            [[theValue(stringValidator.state) should] equal:theValue(AJWValidatorValidationStateInvalid)];
        });
        specify(^{
            [[theValue(numericValidator.state) should] equal:theValue(AJWValidatorValidationStateInvalid)];
        });
    });
    
    context(@"custom condition is satisfied", ^{
        beforeEach(^{
            [stringValidator validate:@"hello"];
            [numericValidator validate:@5];
        });
        specify(^{
            [[theValue(stringValidator.state) should] equal:theValue(AJWValidatorValidationStateValid)];
        });
        specify(^{
            [[theValue(numericValidator.state) should] equal:theValue(AJWValidatorValidationStateValid)];
        });
    });
    
});

SPEC_END
