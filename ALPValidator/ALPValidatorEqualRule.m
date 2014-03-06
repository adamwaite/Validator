//
//  ALPValidatorEqualRule.m
//  ALPValidator
//
//  Created by Adam Waite on 31/01/2014.
//  Copyright (c) 2014 Alpaca Labs. All rights reserved.
//

#import "ALPValidatorEqualRule.h"

@interface ALPValidatorEqualRule ()

@property (strong, nonatomic) id otherInstance;

@end

@implementation ALPValidatorEqualRule

#pragma mark Init

- (id)initWithType:(ALPValidatorRuleType)type invalidMessage:(NSString *)message otherInstance:(id)instance
{
    self = [super initWithType:type invalidMessage:message];
    if (self) {
        _otherInstance = instance;
    }
    return self;
}

#pragma mark Validate

- (BOOL)isValidationRuleSatisfied:(id)instance
{
    return [instance isEqual:self.otherInstance];
}

@end