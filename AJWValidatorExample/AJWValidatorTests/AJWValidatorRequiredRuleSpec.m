#import "Kiwi.h"
#import "AJWValidator.h"

SPEC_BEGIN(AJWValidatorRequiredRuleSpec)

describe(@"AJWValidatorRequiredRule", ^{
    
    __block AJWValidator *stringValidator;
    __block AJWValidator *numericValidator;
    
    beforeEach(^{
        stringValidator = [AJWValidator validatorWithType:AJWValidatorTypeString];
        numericValidator = [AJWValidator validatorWithType:AJWValidatorTypeNumeric];
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
            [[theValue(stringValidator.state) should] equal:theValue(AJWValidatorValidationStateInvalid)];
        });
    });
        
    context(@"passing empty string", ^{
        beforeEach(^{
            [stringValidator validate:@""];
        });
        specify(^{
            [[theValue(stringValidator.state) should] equal:theValue(AJWValidatorValidationStateInvalid)];
        });
    });
        
    context(@"passing valid string", ^{
        beforeEach(^{
            [stringValidator validate:@"hello"];
        });
        specify(^{
            [[theValue(stringValidator.state) should] equal:theValue(AJWValidatorValidationStateValid)];
        });
    });

});

SPEC_END
