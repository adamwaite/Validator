//
//  UIControlPlusALPValidatorSpec.m
//  ALPValidator
//
//  Created by Adam Waite on 29/03/2014.
//  Copyright (c) 2014 Alpaca Labs. All rights reserved.
//

#import "Kiwi.h"
#import "ALPValidator.h"

SPEC_BEGIN(UIControlPlusALPValidatorSpec)

describe(@"UIControl+ALPValidator", ^{
    
    UIControl *control = [[UIControl alloc] initWithFrame:CGRectZero];
    
    describe(@"Methods", ^{
        specify(^{
            [[control should] respondToSelector:@selector(attachValidator:)];
        });
        
        specify(^{
            [[control should] respondToSelector:@selector(removeValidators)];
        });
    });
    
    describe(@"Attaching a validator", ^{
        
        ALPValidator *validator = [ALPValidator validatorWithType:ALPValidatorTypeString];
        UITextField *supported = [[UITextField alloc] initWithFrame:CGRectZero];
        UIStepper *unsupported = [[UIStepper alloc] initWithFrame:CGRectZero];
        
        specify(^{
            [[theBlock(^{
                [supported attachValidator:nil];
            }) should] raise];
        });
        
        specify(^{
            [[theBlock(^{
                [unsupported attachValidator:validator];
            }) should] raise];
        });
        
        specify(^{
            [[theBlock(^{
                [supported attachValidator:validator];
            }) shouldNot] raise];
        });
        
    });
    
    context(@"UITextField automatic validation", ^{
        
        __block UITextField *field;
        __block ALPValidator *validator;
        
        beforeEach(^{
            
            field = [[UITextField alloc] initWithFrame:CGRectZero];
            field.backgroundColor = [UIColor greenColor];
            
            validator  = [ALPValidator validatorWithType:ALPValidatorTypeString];
            [validator addValidationToEnsureMaximumLength:3 invalidMessage:nil];
            validator.validatorStateChangedHandler = ^(ALPValidatorState state){
                if (state == ALPValidatorValidationStateInvalid) {
                    field.backgroundColor = [UIColor redColor];
                }
            };
            
            [field attachValidator:validator];
            
        });
        
        context(@"Valid", ^{
            
            beforeEach(^{
                field.text = @"hi";
                [field sendActionsForControlEvents:UIControlEventEditingChanged];
            });
            
            specify(^{
                [[field.backgroundColor shouldNot] equal:[UIColor redColor]];
            });
            
        });
        
        context(@"Invalid", ^{
            
            beforeEach(^{
                field.text = @"hiya";
                [field sendActionsForControlEvents:UIControlEventEditingChanged];
            });
            
            specify(^{
                [[field.backgroundColor should] equal:[UIColor redColor]];
            });
            
        });
        
    });
    
});

SPEC_END
