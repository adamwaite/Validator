/*
 
 AJWValidatorRule.m
 AJWValidator
 
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

#import "AJWValidatorRule.h"

const NSString * AJWValidatorRuleDefaultErrorMessageForType(AJWValidatorRuleType type) {
    switch (type) {
        case AJWValidatorRuleTypeRequired:              return @"String is required.";
        case AJWValidatorRuleTypeMinLength:             return @"String is too short.";
        case AJWValidatorRuleTypeMaxLength:             return @"String is too long.";
        case AJWValidatorRuleTypeEmail:                 return @"String isn't a valid email address.";
        case AJWValidatorRuleTypeRegex:                 return @"String doesn't match a pattern.";
        case AJWValidatorRuleTypeRemote:                return @"String doesn't satisfy a remote condition.";
        case AJWValidatorRuleTypeCustom:                return @"String doesn't satisfy a custom condition.";
        case AJWValidatorRuleTypeStringRange:           return @"String character length is not in the correct range.";
        case AJWValidatorRuleTypeNumericRange:          return @"Number is not in the correct range..";
        case AJWValidatorRuleTypeEqual:                 return @"Instance should be identical to another instance";
        case AJWValidatorRuleTypeStringContainsNumber:  return @"String requires a numeric character.";
    }
}

@interface AJWValidatorRule ()

@property (nonatomic) AJWValidatorRuleType type;
@property (copy, nonatomic) NSString *errorMessage;

@end

@implementation AJWValidatorRule

#pragma mark Init

- (id)initWithType:(AJWValidatorRuleType)type invalidMessage:(NSString *)message
{
    self = [super init];
    if (self) {
        _type = type;
        _errorMessage = message;
        if (!message) _errorMessage = AJWValidatorRuleDefaultErrorMessageForType(type);
    }
    return self;
}

#pragma mark Validate

- (BOOL)isValidationRuleSatisfied:(id)instance
{
    return NO;
}

@end