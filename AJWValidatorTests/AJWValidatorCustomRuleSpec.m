#import "Kiwi.h"
#import "ALPValidator.h"

SPEC_BEGIN(ALPValidatorCustomRuleSpec)

describe(@"ALPValidatorCustomRule", ^{
    
    ALPValidatorCustomRuleBlock noLetterACustomRule = ^BOOL(NSString *instance){
        return ([instance rangeOfString:@"A"].location == NSNotFound);
    };
    
    ALPValidatorCustomRuleBlock numberIsFive = ^BOOL(NSNumber *instance){
        return ([instance isEqual:@5]);
    };
    
    __block ALPValidator *stringValidator;
    __block ALPValidator *numericValidator;
    
    beforeEach(^{
        stringValidator = [ALPValidator validatorWithType:ALPValidatorTypeString];
        numericValidator = [ALPValidator validatorWithType:ALPValidatorTypeNumeric];
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
            [[theValue(stringValidator.state) should] equal:theValue(ALPValidatorValidationStateInvalid)];
        });
        specify(^{
            [[theValue(numericValidator.state) should] equal:theValue(ALPValidatorValidationStateInvalid)];
        });
    });
    
    context(@"custom condition is satisfied", ^{
        beforeEach(^{
            [stringValidator validate:@"hello"];
            [numericValidator validate:@5];
        });
        specify(^{
            [[theValue(stringValidator.state) should] equal:theValue(ALPValidatorValidationStateValid)];
        });
        specify(^{
            [[theValue(numericValidator.state) should] equal:theValue(ALPValidatorValidationStateValid)];
        });
    });
    
});

SPEC_END
