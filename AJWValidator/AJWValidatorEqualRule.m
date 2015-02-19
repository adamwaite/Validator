//
//  AJWValidatorEqualRule.m
//  AJWValidator
//
//  Created by Adam Waite on 31/01/2014.
//  Copyright (c) 2014 Adam Waite. All rights reserved.
//

#import "AJWValidatorEqualRule.h"

@interface AJWValidatorEqualRule ()

@property (strong, nonatomic) id otherInstance;

@end

@implementation AJWValidatorEqualRule

#pragma mark Init

- (id)initWithType:(AJWValidatorRuleType)type invalidMessage:(NSString *)message otherInstance:(id)instance
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