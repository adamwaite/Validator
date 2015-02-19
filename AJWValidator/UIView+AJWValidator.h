//
//  UIView+AJWValidator.h
//  AJWValidator
//
//  Created by Michael Gaylord on 2014/08/28.
//  Copyright (c) 2014 Adam Waite. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AJWValidator;

@interface UIView (AJWValidator)

/**
 *  Adds a validator to the control instance and validates on value change
 *
 *  @param validator to add
 */
- (void)ajw_attachValidator:(AJWValidator *)validator;

/**
 *  Removes all attached validators
 */
- (void)ajw_removeValidators;

#pragma mark Deprected

- (void)attachValidator:(AJWValidator *)validator __attribute__((deprecated));
- (void)removeValidators __attribute__((deprecated));

@end
