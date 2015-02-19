//
//  AJWValidatorRangeRule.m
//  AJWValidator
//
//  Created by Adam Waite on 31/01/2014.
//  Copyright (c) 2014 Adam Waite. All rights reserved.
//

#import "AJWValidatorRangeRule.h"

@interface AJWValidatorRangeRule ()

@property (strong, nonatomic) NSNumber *min;
@property (strong, nonatomic) NSNumber *max;

@end

@implementation AJWValidatorRangeRule

#pragma mark Init

- (id)initWithType:(AJWValidatorRuleType)type invalidMessage:(NSString *)message minimum:(NSNumber *)min maximum:(NSNumber *)max
{
    self = [super initWithType:type invalidMessage:message];
    if (self) {
        _min = min;
        _max = max;
    }
    return self;
}

#pragma mark Validate

- (BOOL)isValidationRuleSatisfied:(id)instance
{
    switch (self.type) {
        case AJWValidatorRuleTypeNumericRange: {
            float numberToValidate = [(NSNumber *)instance floatValue];
            float minVal = [self.min floatValue];
            float maxVal = [self.max floatValue];
            return ((numberToValidate >= minVal) && (numberToValidate <= maxVal));
        }
        case AJWValidatorRuleTypeStringRange: {
            NSUInteger minChars = [self.min integerValue];
            NSUInteger maxChars = [self.max integerValue];
            NSString *stringToValidate = (NSString *)instance;
            return (([stringToValidate length] >= minChars) && ([stringToValidate length] <= maxChars));
        }
        default: {
            return NO;
        }
    }
}

@end
