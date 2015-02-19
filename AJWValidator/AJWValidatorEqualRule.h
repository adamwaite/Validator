//
//  AJWValidatorEqualRule.h
//  AJWValidator
//
//  Created by Adam Waite on 31/01/2014.
//  Copyright (c) 2014 Adam Waite. All rights reserved.
//

#import "AJWValidatorRule.h"

@interface AJWValidatorEqualRule : AJWValidatorRule

- (id)initWithType:(AJWValidatorRuleType)type invalidMessage:(NSString *)message otherInstance:(id)instance;

@end
