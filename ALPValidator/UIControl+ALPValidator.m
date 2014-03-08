/*
 
 UIControl+ALPValidator.m
 ALPValidator
 
 Created by @adamwaite.
 
 Copyright (c) 2014 Adam Waite. All rights reserved.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

#import "UIControl+ALPValidator.h"
#import "ALPValidator.h"
#import <objc/runtime.h>

static char ALPValidatorUIControlValidators;

@implementation UIControl (ALPValidator)

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
    [self addTarget:self action:@selector(validateForChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)removeValidators
{
    [[self validators] removeAllObjects];
}

#pragma mark Validating

- (void)validateForChange:(id)sender
{
    if ([sender isKindOfClass:[UITextField class]]) {
        [self validateTextFieldForChange:sender];
    }

    if ([sender isKindOfClass:[UITextView class]]) {
        [self validateTextViewForChange:sender];
    }
}

- (void)validateTextFieldForChange:(UITextField *)textField
{
    [[self validators] enumerateObjectsUsingBlock:^(ALPValidator *validator, NSUInteger idx, BOOL *stop) {
        [validator validate:textField.text];
    }];
}

- (void)validateTextViewForChange:(UITextView *)textView
{
    [[self validators] enumerateObjectsUsingBlock:^(ALPValidator *validator, NSUInteger idx, BOOL *stop) {
        [validator validate:textView.text];
    }];
}

@end