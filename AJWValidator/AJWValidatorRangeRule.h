//
//  AJWValidatorRangeRule.h
//  AJWValidator
//
//  Created by Adam Waite on 31/01/2014.
//  Copyright (c) 2014 Adam Waite. All rights reserved.
//

#import "AJWValidatorRule.h"

@interface AJWValidatorRangeRule : AJWValidatorRule

- (id)initWithType:(AJWValidatorRuleType)type invalidMessage:(NSString *)message minimum:(NSNumber *)min maximum:(NSNumber *)max;

@end