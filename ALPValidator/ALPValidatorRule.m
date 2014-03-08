/*
 
 ALPValidatorRule.m
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

#import "ALPValidatorRule.h"

const NSString * ALPValidatorRuleDefaultErrorMessageForType(ALPValidatorRuleType type) {
    switch (type) {
        case ALPValidatorRuleTypeRequired:              return @"String is required.";
        case ALPValidatorRuleTypeMinLength:             return @"String is too short.";
        case ALPValidatorRuleTypeMaxLength:             return @"String is too long.";
        case ALPValidatorRuleTypeEmail:                 return @"String isn't a valid email address.";
        case ALPValidatorRuleTypeRegex:                 return @"String doesn't match a pattern.";
        case ALPValidatorRuleTypeRemote:                return @"String doesn't satisfy a remote condition.";
        case ALPValidatorRuleTypeCustom:                return @"String doesn't satisfy a custom condition.";
        case ALPValidatorRuleTypeStringRange:           return @"String character length is not in the correct range.";
        case ALPValidatorRuleTypeNumericRange:          return @"Number is not in the correct range..";
        case ALPValidatorRuleTypeEqual:                 return @"Instance should be identical to another instance";
        case ALPValidatorRuleTypeStringContainsNumber:  return @"String requires a numeric character.";
    }
}

@interface ALPValidatorRule ()

@property (nonatomic) ALPValidatorRuleType type;
@property (copy, nonatomic) NSString *errorMessage;

@end

@implementation ALPValidatorRule

#pragma mark Init

- (id)initWithType:(ALPValidatorRuleType)type invalidMessage:(NSString *)message
{
    self = [super init];
    if (self) {
        _type = type;
        _errorMessage = message;
        if (!message) _errorMessage = ALPValidatorRuleDefaultErrorMessageForType(type);
    }
    return self;
}

#pragma mark Validate

- (BOOL)isValidationRuleSatisfied:(id)instance
{
    return NO;
}

@end