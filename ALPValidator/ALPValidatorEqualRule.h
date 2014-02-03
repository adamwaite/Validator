//
//  ALPValidatorEqualRule.h
//  ALPValidator
//
//  Created by Adam Waite on 31/01/2014.
//  Copyright (c) 2014 Alpaca Labs. All rights reserved.
//

#import "ALPValidatorRule.h"

@interface ALPValidatorEqualRule : ALPValidatorRule

- (id)initWithType:(ALPValidatorRuleType)type invalidMessage:(NSString *)message otherInstance:(id)instance;

@end
