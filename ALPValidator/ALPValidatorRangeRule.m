//
//  ALPValidatorRangeRule.m
//  ALPValidator
//
//  Created by Adam Waite on 31/01/2014.
//  Copyright (c) 2014 Alpaca Labs. All rights reserved.
//

#import "ALPValidatorRangeRule.h"

@interface ALPValidatorRangeRule ()

@property (strong, nonatomic) NSNumber *min;
@property (strong, nonatomic) NSNumber *max;

@end

@implementation ALPValidatorRangeRule

#pragma mark Init

- (id)initWithType:(ALPValidatorRuleType)type invalidMessage:(NSString *)message minimum:(NSNumber *)min maximum:(NSNumber *)max
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
        case ALPValidatorRuleTypeNumericRange: {
            float numberToValidate = [(NSNumber *)instance floatValue];
            float minVal = [_min floatValue];
            float maxVal = [_max floatValue];
            return ((numberToValidate >= minVal) && (numberToValidate <= maxVal));
        }
        case ALPValidatorRuleTypeStringRange: {
            NSUInteger minChars = [_min integerValue];
            NSUInteger maxChars = [_max integerValue];
            NSString *stringToValidate = (NSString *)instance;
            return (([stringToValidate length] >= minChars) && ([stringToValidate length] <= maxChars));
        }
        default: {
            return NO;
        }
    }
}

@end
