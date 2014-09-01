//
//  UITextInput+ALPValidator.m
//  ALPValidator
//
//  Created by Michael Gaylord on 2014/08/28.
//  Copyright (c) 2014 Alpaca Labs. All rights reserved.
//

#import "UIView+ALPValidator.h"
#import "ALPValidator.h"
#import <objc/runtime.h>

static char ALPValidatorUIViewValidators;

typedef NS_ENUM(NSUInteger, ALPValidatorUIViewValidatorsType) {
    ALPValidatorUIViewValidatorsTypeUnsupported,
    ALPValidatorUIViewValidatorsTypeUITextField,
    ALPValidatorUIViewValidatorsTypeUITextView
};

@implementation UIView (ALPValidator)

#pragma mark Associated Object Accessors

- (NSMutableArray *)alp_validators
{
    return objc_getAssociatedObject(self, &ALPValidatorUIViewValidators);
}

#pragma mark Supported Input Views

- (ALPValidatorUIViewValidatorsType)alp_validatorType
{
    if ([self isKindOfClass:[UITextField class]]) {
        return ALPValidatorUIViewValidatorsTypeUITextField;
    }
    
    if ([self isKindOfClass:[UITextView class]]) {
        return ALPValidatorUIViewValidatorsTypeUITextView;
    }
    
    return ALPValidatorUIViewValidatorsTypeUnsupported;
}

#pragma mark Attach/Remove

- (void)alp_attachValidator:(ALPValidator *)validator
{
    NSParameterAssert(validator);
    
    switch ([self alp_validatorType]) {
        case ALPValidatorUIViewValidatorsTypeUITextField:
            [self alp_attachTextFieldValidator];
            break;
        case ALPValidatorUIViewValidatorsTypeUITextView:
            [self alp_attachTextViewValidator];
            break;
        case ALPValidatorUIViewValidatorsTypeUnsupported:
            NSLog(@"Tried to add ALPValidator to unsupported control type of class %@. %s.", [self class], __PRETTY_FUNCTION__);
            return;
    }
    
    if (![self alp_validators]) {
        objc_setAssociatedObject(self, &ALPValidatorUIViewValidators, [NSMutableArray array], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [[self alp_validators] addObject:validator];
    
}

- (void)alp_removeValidators
{
    [[self alp_validators] removeAllObjects];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark UITextField

- (void)alp_attachTextFieldValidator
{
    [(UITextField *)self addTarget:self action:@selector(alp_validateTextFieldForChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)alp_validateTextFieldForChange:(UITextField *)textField
{
    [[self alp_validators] enumerateObjectsUsingBlock:^(ALPValidator *validator, NSUInteger idx, BOOL *stop) {
        [validator validate:textField.text];
    }];
}

#pragma mark UITextView

- (void)alp_attachTextViewValidator
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alp_validateTextViewForChange:) name:UITextViewTextDidChangeNotification object:self];
}

- (void)alp_validateTextViewForChange:(NSNotification *)notification
{
    [[self alp_validators] enumerateObjectsUsingBlock:^(ALPValidator *validator, NSUInteger idx, BOOL *stop) {
        UITextView *textView = notification.object;
        [validator validate:textView.text];
    }];
}

#pragma mark Deprecated

- (void)attachValidator:(ALPValidator *)validator
{
    [self alp_attachValidator:validator];
}

- (void)removeValidators
{
    [self alp_removeValidators];
}

@end
