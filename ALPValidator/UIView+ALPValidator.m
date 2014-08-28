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

static char ALPValidatorUIControlValidators;


@implementation UIView (ALPValidator)

#pragma mark Associated Object Accessors

- (NSMutableArray *)validators
{
    return objc_getAssociatedObject(self, &ALPValidatorUIControlValidators);
}

#pragma mark Attach/Remove

- (void)attachValidator:(ALPValidator *)validator
{
    
    NSParameterAssert(validator);
    
    if (![self validators]) {
        objc_setAssociatedObject(self, &ALPValidatorUIControlValidators, [NSMutableArray array], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    NSArray *supported = @[
                           [UITextField class],
                           [UITextView class]
                           ];
    
    __block BOOL isSupported = NO;
    
    [supported enumerateObjectsUsingBlock:^(Class instanceType, NSUInteger idx, BOOL *stop) {
        isSupported = [self isKindOfClass:instanceType];
        if (isSupported) {
            *stop = YES;
        }
    }];
    
    if (!isSupported) {
        [NSException raise:@"ALPValidator Error" format:@"Tried to add ALPValidator to unsupported control type of class %@. %s.", [self class], __PRETTY_FUNCTION__];
    }
    
    [[self validators] addObject:validator];
    
    if ([self isKindOfClass:[UITextField class]]) {
        [(UITextField *)self addTarget:self action:@selector(validateTextFieldForChange:) forControlEvents:UIControlEventEditingChanged];
    } else if ([self isKindOfClass:[UITextView class]]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(validateTextViewForChange:)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:self];
    }
    
}

- (void)removeValidators
{
    [[self validators] removeAllObjects];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Validating

- (void)validateTextFieldForChange:(UITextField *)textField {
    [[self validators] enumerateObjectsUsingBlock:^(ALPValidator *validator, NSUInteger idx, BOOL *stop) {
        [validator validate:textField.text];
    }];
}

- (void)validateTextViewForChange:(NSNotification *) notification
{
    [[self validators] enumerateObjectsUsingBlock:^(ALPValidator *validator, NSUInteger idx, BOOL *stop) {
        UITextView *textView = notification.object;
        [validator validate:textView.text];
    }];
}

@end
