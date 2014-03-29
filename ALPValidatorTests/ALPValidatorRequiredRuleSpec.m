#import "Kiwi.h"
#import "ALPValidator.h"

SPEC_BEGIN(ALPValidatorRequiredRuleSpec)

describe(@"ALPValidatorRequiredRule", ^{
    
    __block ALPValidator *stringValidator;
    __block ALPValidator *numericValidator;
    
    beforeEach(^{
        stringValidator = [ALPValidator validatorWithType:ALPValidatorTypeString];
        numericValidator = [ALPValidator validatorWithType:ALPValidatorTypeNumeric];
        [stringValidator addValidationToEnsurePresenceWithInvalidMessage:nil];
    });
    
    specify(^{
        [[theValue(stringValidator.ruleCount) should] equal:theValue(1)];
    });
        
    specify(^{
        [[theBlock(^{
            [numericValidator addValidationToEnsurePresenceWithInvalidMessage:nil];
        }) should] raise];
    });
        
    context(@"passing nil", ^{
        [stringValidator validate:nil];
        [numericValidator validate:nil];
        specify(^{
            [[theValue(stringValidator.state) should] equal:theValue(ALPValidatorValidationStateInvalid)];
        });
    });
        
    context(@"passing empty string", ^{
        beforeEach(^{
            [stringValidator validate:@""];
        });
        specify(^{
            [[theValue(stringValidator.state) should] equal:theValue(ALPValidatorValidationStateInvalid)];
        });
    });
        
    context(@"passing valid string", ^{
        beforeEach(^{
            [stringValidator validate:@"hello"];
        });
        specify(^{
            [[theValue(stringValidator.state) should] equal:theValue(ALPValidatorValidationStateValid)];
        });
    });

});

SPEC_END
