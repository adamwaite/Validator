#import "Kiwi.h"
#import "AJWValidator.h"

SPEC_BEGIN(ALPValidatotEqualRuleSpec)

describe(@"ALPValidatotEqualRule", ^{
    
    __block AJWValidator *stringValidator;
    __block AJWValidator *numericValidator;
    
    beforeEach(^{
        stringValidator = [AJWValidator validatorWithType:AJWValidatorTypeString];
        numericValidator = [AJWValidator validatorWithType:AJWValidatorTypeNumeric];
        [stringValidator addValidationToEnsureInstanceIsTheSameAs:@"p4ssword" invalidMessage:nil];
        [numericValidator addValidationToEnsureInstanceIsTheSameAs:@5 invalidMessage:nil];
    });
    
    specify(^{
        [[theValue(stringValidator.ruleCount) should] equal:theValue(1)];
    });
    
    specify(^{
        [[theValue(numericValidator.ruleCount) should] equal:theValue(1)];
    });
    
    context(@"unequal strings", ^{
        beforeEach(^{
            [stringValidator validate:@"password"];
        });
        specify(^{
            [[theValue(stringValidator.state) should] equal:theValue(AJWValidatorValidationStateInvalid)];
        });
    });
    
    context(@"equal strings", ^{
        beforeEach(^{
            [stringValidator validate:@"p4ssword"];
        });
        specify(^{
            [[theValue(stringValidator.state) should] equal:theValue(AJWValidatorValidationStateValid)];
        });
    });
    
    context(@"unequal numbers", ^{
        beforeEach(^{
            [numericValidator validate:@4.9];
        });
        specify(^{
            [[theValue(numericValidator.state) should] equal:theValue(AJWValidatorValidationStateInvalid)];
        });
    });
    
    context(@"equal numbers", ^{
        beforeEach(^{
            [numericValidator validate:@5];
        });
        specify(^{
            [[theValue(numericValidator.state) should] equal:theValue(AJWValidatorValidationStateValid)];
        });
    });
    
    describe(@"changing string", ^{
        
        AJWValidator *textFieldValidator = [AJWValidator validatorWithType:AJWValidatorTypeString];
        NSMutableString *changingString = [NSMutableString string];
        changingString = [NSMutableString stringWithString:@"hey"];
        
        beforeEach(^{
            [textFieldValidator addValidationToEnsureInstanceIsTheSameAs:changingString invalidMessage:nil];
            [textFieldValidator validate:@"hey"];
        });
        
        specify(^{
            [[theValue(textFieldValidator.state) should] equal:theValue(AJWValidatorValidationStateValid)];
        });
        
        context(@"when the string chnages", ^{
            beforeEach(^{
                [changingString appendString:@"a"];
                [textFieldValidator validate:@"hey"];
            });
            specify(^{
                [[theValue(textFieldValidator.state) shouldNot] equal:theValue(AJWValidatorValidationStateValid)];
            });
        });
        
    });
    
});

SPEC_END
