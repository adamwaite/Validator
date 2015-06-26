/*
 
 AJWValidator.h
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

#import <Foundation/Foundation.h>
#import "UIView+AJWValidator.h"

@class AJWValidator;

/**
 *  Validator type.
 */
typedef NS_ENUM(NSUInteger, AJWValidatorType) {
    /**
     *  Validates any instance, many rules incompatible
     */
    AJWValidatorTypeGeneric,
    /**
     *  Validates string instances
     */
    AJWValidatorTypeString,
    /**
     *  Validates numeric instances
     */
    AJWValidatorTypeNumeric
};


/**
 *  Describes validation state
 */
typedef NS_ENUM(NSUInteger, AJWValidatorState) {
    /**
     *  Invalid state
     */
    AJWValidatorValidationStateInvalid,
    /**
     *  Valid state
     */
    AJWValidatorValidationStateValid,
    /**
     *  Waiting on a remote response to determine validation state
     */
    AJWValidatorValidationStateWaitingForRemote
};

/**
 *  Block called on validation state change
 *
 *  @see validatorStateChangedHandler
 *
 *  @param AJWValidatorState state of the validation
 */
typedef void (^AJWValidatorStateChangeHandler)(AJWValidatorState);

/**
 *  Block added to a custom rule
 *
 *  @param id Instance to validate
 *
 *  @return BOOL YES for valid, NO for invalid
 */
typedef BOOL (^AJWValidatorCustomRuleBlock)(id);

/**
 *  Regular expression for validating email addresses.
 */
extern NSString * const AJWValidatorRegularExpressionPatternEmail;

/**
 *  Regular expression for ensuring a numeric character.
 */
extern NSString * const AJWValidatorRegularExpressionPatternContainsNumber;

/**
 *  Optionally conform to AJWValidatorDelegate to receive notifications when a server responds successfully or a request fails
 */
@protocol AJWValidatorDelegate <NSObject>

@optional

/**
 *  Successful response
 *
 *  @param validator            Validator instance
 *  @param url                  Remote location
 *  @param remoteConditionValid Valid or invalid
 */
- (void)validator:(AJWValidator *)validator
remoteValidationAtURL:(NSURL *)url
   receivedResult:(BOOL)remoteConditionValid;

/**
 *  Failed response
 *
 *  @param validator Validator instance
 *  @param url       Remote location
 *  @param error     Response error
 */
- (void)validator:(AJWValidator *)validator
remoteValidationAtURL:(NSURL *)url
  failedWithError:(NSError *)error;

@end

/**
 *  AJWValidator validates user input based on added validaton rules, manages error messages and handles input state change.
 */
@interface AJWValidator : NSObject

/**
 *  AJWValidatorDelegate delegate property
 *  
 *  @see AJWValidatorDelegate
 */
@property (weak, nonatomic) id <AJWValidatorDelegate> delegate;

/**
 *  If set, the block runs when validation state changes
 */
@property (copy, nonatomic) AJWValidatorStateChangeHandler validatorStateChangedHandler;

/**
 *  Describes the last state of the validation
 *
 *  @see AJWValidatorState
 */
@property (nonatomic, readonly) AJWValidatorState state;

/**
 *  Returns the number of rules the validator has
 */
@property (readonly) NSUInteger ruleCount;

/**
 *  An array of validation error messages for failed validations
 */
@property (copy, nonatomic, readonly) NSArray *errorMessages;

/**
 *  Creates and returns a generic validator
 *
 *  @return AJWValidator instance
 */
+ (instancetype)validator;

/**
 *  Initialiser with type (recommended)
 *
 *  @param type Type of instance you would like to validate
 *
 *  @return AJWValidator instance
 */
+ (instancetype)validatorWithType:(AJWValidatorType)type;

/**
 *  Add a validation rule to ensure presence
 *
 *  @param message message to add to errorMessages if invalid
 */
- (void)addValidationToEnsurePresenceWithInvalidMessage:(NSString *)message;

/**
 *  Add a validation rule to ensure a minimum length is met
 *
 *  @param minLength minimum length
 *  @param message   message message to add to errorMessages if invalid
 */
- (void)addValidationToEnsureMinimumLength:(NSUInteger)minLength
                            invalidMessage:(NSString *)message;

/**
 *  Add a validation rule to ensure a maximum length hasn't been exceeded
 *
 *  @param maxLength max lenth
 *  @param message   message message to add to errorMessages if invalid
 */
- (void)addValidationToEnsureMaximumLength:(NSUInteger)maxLength
                            invalidMessage:(NSString *)message;

/**
 *  Add a validation rule to ensure the input length is between a range
 *
 *  @param min     minimum length
 *  @param max     maximum length
 *  @param message message message to add to errorMessages if invalid
 */
- (void)addValidationToEnsureRangeWithMinimum:(NSNumber *)min
                                      maximum:(NSNumber *)max
                               invalidMessage:(NSString *)message;

/**
 *  Add a validation rule to check equality
 *
 *  @param otherInstance other instance to check validated instance against
 *  @param message       message message to add to errorMessages if invalid
 */
- (void)addValidationToEnsureInstanceIsTheSameAs:(id)otherInstance
                                  invalidMessage:(NSString *)message;

/**
 *  Add a validation rule to ensure the input matches a pattern defined by a regular expression
 *
 *  @param pattern regular expression
 *  @param message message message to add to errorMessages if invalid
 */
- (void)addValidationToEnsureRegularExpressionIsMetWithPattern:(NSString *)pattern
                                                invalidMessage:(NSString *)message;

/**
 *  Add a validation rule to ensure the input is a valid email address
 *
 *  @param message message message to add to errorMessages if invalid
 */
- (void)addValidationToEnsureValidEmailWithInvalidMessage:(NSString *)message;

/**
 *  Add a validation rule to ensure a remote server-side condition is satisfied
 *
 *  @param url     URL to the condition
 *  @param message message message to add to errorMessages if invalid
 */
- (void)addValidationToEnsureRemoteConditionIsSatisfiedAtURL:(NSURL *)url
                                              invalidMessage:(NSString *)message;

/**
 *  Add a validation rule that evaluates a custom condition
 *
 *  @param block   should return YES for valid and NO for invalid
 *  @param message message message to add to errorMessages if invalid
 */
- (void)addValidationToEnsureCustomConditionIsSatisfiedWithBlock:(AJWValidatorCustomRuleBlock)block
                                                  invalidMessage:(NSString *)message;

/**
 *  Add a validation rule to ensure that the input contains a number
 *
 *  @param message message message to add to errorMessages if invalid
 */
- (void)addValidationToEnsureStringContainsNumberWithInvalidMessage:(NSString *)message;

/**
 *  Validates the instance and changes the state property
 *
 *  @param instance instance to validate (typically a user input)
 */
- (void)validate:(id)instance;

/**
 *  Alias for validate:
 */
- (void)ajwValidate:(id)instance;

/**
 *  Validates an instance and the state property, additional params can be passed in a dicitonary
 *
 *  @param instance   instance to validate
 *  @param parameters any additional parameters required for the validation
 */
- (void)validate:(id)instance parameters:(NSDictionary *)parameters;

/**
 *  Alias for validate:parameters:
 */
- (void)ajwValidate:(id)instance parameters:(NSDictionary *)parameters;

/**
 *  Return YES if last instance validated was deemed valid based on the added rules
 *
 *  @return YES for valid, no otherwise
 */
- (BOOL)isValid;

@end