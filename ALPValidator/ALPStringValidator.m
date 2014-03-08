/*
 
 ALPValidator.m
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

#import "ALPStringValidator.h"
#import "ALPValidator+Private.h"
#import "ALPValidatorRequiredRule.h"
#import "ALPValidatorMinimumLengthRule.h"
#import "ALPValidatorMaximumLengthRule.h"
#import "ALPValidatorRangeRule.h"
#import "ALPValidatorRegularExpressionRule.h"

@interface ALPStringValidator ()
@end

@implementation ALPStringValidator

#pragma mark Init

- (id)init
{
    self = [self initWithType:ALPValidatorTypeString];
    if (self) {
        
    }
    return self;
}

#pragma mark Add Rules

- (void)addValidationToEnsurePresenceWithInvalidMessage:(NSString *)message
{
    ALPValidatorRequiredRule *rule = [[ALPValidatorRequiredRule alloc] initWithType:ALPValidatorRuleTypeRequired invalidMessage:message];
    [self addValidationRule:rule];
}

- (void)addValidationToEnsureMinimumLength:(NSUInteger)minLength invalidMessage:(NSString *)message
{
    ALPValidatorMinimumLengthRule *rule = [[ALPValidatorMinimumLengthRule alloc] initWithType:ALPValidatorRuleTypeMinLength invalidMessage:message minLength:minLength];
    [self addValidationRule:rule];
}

- (void)addValidationToEnsureMaximumLength:(NSUInteger)maxLength invalidMessage:(NSString *)message
{
    ALPValidatorMaximumLengthRule *rule = [[ALPValidatorMaximumLengthRule alloc] initWithType:ALPValidatorRuleTypeMaxLength invalidMessage:message maxLength:maxLength];
    [self addValidationRule:rule];
}

- (void)addValidationToEnsureRangeWithMinimum:(NSNumber *)min maximum:(NSNumber *)max invalidMessage:(NSString *)message
{
    ALPValidatorRangeRule *rule = [[ALPValidatorRangeRule alloc] initWithType:ALPValidatorRuleTypeStringRange invalidMessage:message minimum:min maximum:max];
    [self addValidationRule:rule];
}

- (void)addValidationToEnsureRegularExpressionIsMetWithPattern:(NSString *)pattern invalidMessage:(NSString *)message
{
    ALPValidatorRegularExpressionRule *rule = [[ALPValidatorRegularExpressionRule alloc] initWithType:ALPValidatorRuleTypeRegex invalidMessage:message pattern:pattern];
    [self addValidationRule:rule];
}

- (void)addValidationToEnsureValidEmailWithInvalidMessage:(NSString *)message
{
    ALPValidatorRegularExpressionRule *rule = [[ALPValidatorRegularExpressionRule alloc] initWithType:ALPValidatorRuleTypeEmail invalidMessage:message pattern:ALPValidatorRegularExpressionPatternEmail];
    [self addValidationRule:rule];
}

- (void)addValidationToEnsureStringContainsNumberWithInvalidMessage:(NSString *)message
{
    ALPValidatorRegularExpressionRule *rule = [[ALPValidatorRegularExpressionRule alloc] initWithType:ALPValidatorRuleTypeStringContainsNumber invalidMessage:message pattern:ALPValidatorRegularExpressionPatternContainsNumber];
    [self addValidationRule:rule];
}

@end
