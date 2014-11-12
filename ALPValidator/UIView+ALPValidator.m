//
//  UITextInput+ALPValidator.m
//  ALPValidator
//
//  Created by Michael Gaylord on 2014/08/28.
//  Copyright (c) 2014 Adam Waite. All rights reserved.
//

#import "UIView+ALPValidator.h"
#import "ALPValidator.h"
#import <objc/runtime.h>

static char ALPValidators;

typedef NS_ENUM(NSUInteger, ALPValidatorInputType) {
    ALPValidatorInputTypeUnsupported,
    ALPValidatorInputTypeUITextField,
    ALPValidatorInputTypeUITextView
};

@implementation UIView (ALPValidator)

#pragma mark Associated Object Accessors

- (NSMutableArray *)alp_validators
{
    return objc_getAssociatedObject(self, &ALPValidators);
}

#pragma mark Supported Input Views

- (ALPValidatorInputType)alp_validatorType
{
    if ([self isKindOfClass:[UITextField class]]) {
        return ALPValidatorInputTypeUITextField;
    }
    
    if ([self isKindOfClass:[UITextView class]]) {
        return ALPValidatorInputTypeUITextView;
    }
    
    return ALPValidatorInputTypeUnsupported;
}

#pragma mark Attach/Remove

- (void)alp_attachValidator:(ALPValidator *)validator
{
    NSParameterAssert(validator);
    
    switch ([self alp_validatorType]) {
        case ALPValidatorInputTypeUITextField:
            [self alp_attachTextFieldValidator];
            break;
        case ALPValidatorInputTypeUITextView:
            [self alp_attachTextViewValidator];
            break;
        case ALPValidatorInputTypeUnsupported:
            NSLog(@"Tried to add ALPValidator to unsupported control type of class %@. %s.", [self class], __PRETTY_FUNCTION__);
            NSAssert(NO, nil);
    }
    
    if (![self alp_validators]) {
        objc_setAssociatedObject(self, &ALPValidators, [NSMutableArray array], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
