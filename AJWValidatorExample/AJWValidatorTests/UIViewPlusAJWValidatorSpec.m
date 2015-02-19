//
//  UIControlPlusAJWValidatorSpec.m
//  AJWValidator
//
//  Created by Adam Waite on 29/03/2014.
//  Copyright (c) 2014 Adam Waite. All rights reserved.
//

#import "Kiwi.h"
#import "AJWValidator.h"

SPEC_BEGIN(UIViewPlusAJWValidatorSpec)

describe(@"View+AJWValidator", ^{
    
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
        
        AJWValidator *validator = [AJWValidator validatorWithType:AJWValidatorTypeString];
        UITextField *supported = [[UITextField alloc] initWithFrame:CGRectZero];
        UIStepper *unsupported = [[UIStepper alloc] initWithFrame:CGRectZero];
        
        specify(^{
            [[theBlock(^{
                [supported ajw_attachValidator:nil];
            }) should] raise];
        });
        
        specify(^{
            [[theBlock(^{
                [unsupported ajw_attachValidator:validator];
            }) should] raise];
        });
        
        specify(^{
            [[theBlock(^{
                [supported ajw_attachValidator:validator];
            }) shouldNot] raise];
        });
        
    });
    
    context(@"UITextField automatic validation", ^{
        
        __block UITextField *field;
        __block AJWValidator *validator;
        
        beforeEach(^{
            
            field = [[UITextField alloc] initWithFrame:CGRectZero];
            field.backgroundColor = [UIColor greenColor];
            
            validator  = [AJWValidator validatorWithType:AJWValidatorTypeString];
            [validator addValidationToEnsureMaximumLength:3 invalidMessage:nil];
            validator.validatorStateChangedHandler = ^(AJWValidatorState state){
                if (state == AJWValidatorValidationStateInvalid) {
                    field.backgroundColor = [UIColor redColor];
                }
            };
            
            [field ajw_attachValidator:validator];
            
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
