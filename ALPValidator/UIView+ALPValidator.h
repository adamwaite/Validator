//
//  UITextInput+ALPValidator.h
//  ALPValidator
//
//  Created by Michael Gaylord on 2014/08/28.
//  Copyright (c) 2014 Alpaca Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALPValidator;

@interface UIView (ALPValidator)

/**
 *  Adds a validator to the control instance and validates on value change
 *
 *  @param validator to add
 */
- (void)alp_attachValidator:(ALPValidator *)validator;

/**
 *  Removes all attached validators
 */
- (void)alp_removeValidators;

#pragma mark Deprected

- (void)attachValidator:(ALPValidator *)validator __attribute__((deprecated));
- (void)removeValidators __attribute__((deprecated));

@end
