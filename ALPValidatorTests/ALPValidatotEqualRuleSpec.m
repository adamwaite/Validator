#import "Kiwi.h"
#import "ALPValidator.h"

SPEC_BEGIN(ALPValidatotEqualRuleSpec)

describe(@"ALPValidatotEqualRule", ^{
    
    __block ALPValidator *stringValidator;
    __block ALPValidator *numericValidator;
    
    beforeEach(^{
        stringValidator = [ALPValidator validatorWithType:ALPValidatorTypeString];
        numericValidator = [ALPValidator validatorWithType:ALPValidatorTypeNumeric];
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
            [[theValue(stringValidator.state) should] equal:theValue(ALPValidatorValidationStateInvalid)];
        });
    });
    
    context(@"equal strings", ^{
        beforeEach(^{
            [stringValidator validate:@"p4ssword"];
        });
        specify(^{
            [[theValue(stringValidator.state) should] equal:theValue(ALPValidatorValidationStateValid)];
        });
    });
    
    context(@"unequal numbers", ^{
        beforeEach(^{
            [numericValidator validate:@4.9];
        });
        specify(^{
            [[theValue(numericValidator.state) should] equal:theValue(ALPValidatorValidationStateInvalid)];
        });
    });
    
    context(@"equal numbers", ^{
        beforeEach(^{
            [numericValidator validate:@5];
        });
        specify(^{
            [[theValue(numericValidator.state) should] equal:theValue(ALPValidatorValidationStateValid)];
        });
    });
    
    describe(@"changing string", ^{
        
        ALPValidator *textFieldValidator = [ALPValidator validatorWithType:ALPValidatorTypeString];
        NSMutableString *changingString = [NSMutableString string];
        changingString = [NSMutableString stringWithString:@"hey"];
        
        beforeEach(^{
            [textFieldValidator addValidationToEnsureInstanceIsTheSameAs:changingString invalidMessage:nil];
            [textFieldValidator validate:@"hey"];
        });
        
        specify(^{
            [[theValue(textFieldValidator.state) should] equal:theValue(ALPValidatorValidationStateValid)];
        });
        
        context(@"when the string chnages", ^{
            beforeEach(^{
                [changingString appendString:@"a"];
                [textFieldValidator validate:@"hey"];
            });
            specify(^{
                [[theValue(textFieldValidator.state) shouldNot] equal:theValue(ALPValidatorValidationStateValid)];
            });
        });
        
    });
    
});

SPEC_END
