/*
 
 AJWValidator.m
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

#import "AJWValidator.h"
#import "AJWStringValidator.h"
#import "AJWNumericValidator.h"
#import "AJWValidatorRule.h"
#import "AJWValidatorEqualRule.h"
#import "AJWValidatorCustomRule.h"
#import "AJWValidatorRemoteRule.h"

const NSString * NSStringFromAJWValidatorType(AJWValidatorType type) {
    switch (type) {
        case AJWValidatorTypeString: return @"String";
        case AJWValidatorTypeNumeric: return @"Numeric";
        default: return nil;
    }
}

const NSString * NSStringFromAJWValidatorState(AJWValidatorState state) {
    switch (state) {
        case AJWValidatorValidationStateInvalid: return @"Invalid";
        case AJWValidatorValidationStateValid: return @"Valid";
        case AJWValidatorValidationStateWaitingForRemote: return @"Waiting for remote validation";
        default: return nil;
    }
}

NSString * const AJWValidatorRegularExpressionPatternEmail = @"^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-+]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z‌​]{2,4})$";

NSString * const AJWValidatorRegularExpressionPatternContainsNumber = @".*\\d.*";

@interface AJWValidator ()

@property (nonatomic) AJWValidatorType type;
@property (nonatomic) AJWValidatorState state;
@property (strong, nonatomic) NSMutableArray *rules;
@property (nonatomic) BOOL localConditionsSatisfied;
@property (strong, nonatomic) NSMutableArray *mutableErrorMessages;

@end

@implementation AJWValidator

#pragma mark Init

+ (instancetype)validator
{
    return [[AJWValidator alloc] initWithType:AJWValidatorTypeGeneric];
}

+ (instancetype)validatorWithType:(AJWValidatorType)type
{
    switch (type) {
        case AJWValidatorTypeGeneric:
            return [AJWValidator validator];
        case AJWValidatorTypeString:
            return [AJWStringValidator new];
        case AJWValidatorTypeNumeric:
            return [AJWNumericValidator new];
    }
}

- (instancetype)init
{
    return [self initWithType:AJWValidatorTypeGeneric];
}

- (instancetype)initWithType:(AJWValidatorType)type
{
    self = [super init];
    if (self) {
        _type = type;
        _rules = [NSMutableArray array];
        _mutableErrorMessages = [NSMutableArray array];
    }
    return self;
}

#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %p: %@", [self class], self, @{
        @"state": NSStringFromAJWValidatorState(self.state),
        @"errorMessages": self.errorMessages
    }];
}

#pragma mark Add Rules

- (void)addValidationRule:(AJWValidatorRule *)rule
{
    [self.rules addObject:rule];
}

- (void)addValidationToEnsurePresenceWithInvalidMessage:(NSString *)message
{
    [self raiseIncompatibilityException];
}

- (void)addValidationToEnsureMinimumLength:(NSUInteger)minLength invalidMessage:(NSString *)message
{
    [self raiseIncompatibilityException];
}

- (void)addValidationToEnsureMaximumLength:(NSUInteger)maxLength invalidMessage:(NSString *)message
{
    [self raiseIncompatibilityException];
}

- (void)addValidationToEnsureRangeWithMinimum:(NSNumber *)min maximum:(NSNumber *)max invalidMessage:(NSString *)message
{
    [self raiseIncompatibilityException];
}

- (void)addValidationToEnsureInstanceIsTheSameAs:(id)otherInstance invalidMessage:(NSString *)message
{
    AJWValidatorEqualRule *rule = [[AJWValidatorEqualRule alloc] initWithType:AJWValidatorRuleTypeEqual
                                                               invalidMessage:message
                                                                otherInstance:otherInstance];
    [self addValidationRule:rule];
}

- (void)addValidationToEnsureRegularExpressionIsMetWithPattern:(NSString *)pattern
                                                invalidMessage:(NSString *)message
{
    [self raiseIncompatibilityException];
}

- (void)addValidationToEnsureValidEmailWithInvalidMessage:(NSString *)message
{
    [self raiseIncompatibilityException];
}

- (void)addValidationToEnsureCustomConditionIsSatisfiedWithBlock:(AJWValidatorCustomRuleBlock)block
                                                  invalidMessage:(NSString *)message
{
    AJWValidatorCustomRule *rule = [[AJWValidatorCustomRule alloc] initWithType:AJWValidatorRuleTypeCustom
                                                                          block:block
                                                                 invalidMessage:message];
    [self addValidationRule:rule];
}

- (void)addValidationToEnsureRemoteConditionIsSatisfiedAtURL:(NSURL *)url
                                              invalidMessage:(NSString *)message
{
    __typeof__(self) __weak weakSelf = self;
    
    AJWValidatorRemoteRule *rule = [[AJWValidatorRemoteRule alloc] initWithType:AJWValidatorRuleTypeRemote
                                                                     serviceURL:(NSURL *)url
                                                                 invalidMessage:message
                                                              completionHandler:^(BOOL remoteConditionSatisfied, NSError *error) {
        
        if (!error) {
            
            if (remoteConditionSatisfied) {
                
                [weakSelf removeValidationMessage:message];
                
                if (weakSelf.localConditionsSatisfied) {
                    weakSelf.state = AJWValidatorValidationStateValid;
                }
                
                else {
                    weakSelf.state = AJWValidatorValidationStateInvalid;
                }
                
            }
            
            else {
                weakSelf.state = AJWValidatorValidationStateInvalid;
            }
            
            if ([weakSelf.delegate respondsToSelector:@selector(validator:remoteValidationAtURL:receivedResult:)]) {
                
                [weakSelf.delegate validator:self
                       remoteValidationAtURL:url
                              receivedResult:remoteConditionSatisfied];
            
            }
        }
                                                                  
        else {
            
            weakSelf.state = AJWValidatorValidationStateInvalid;
            
            if ([weakSelf.delegate respondsToSelector:@selector(validator:remoteValidationAtURL:failedWithError:)]) {
                [weakSelf.delegate validator:self
                       remoteValidationAtURL:url
                             failedWithError:error];
            }
            
        }
                                                                  
    }];
    
    [self addValidationRule:rule];
}

- (void)addValidationToEnsureStringContainsNumberWithInvalidMessage:(NSString *)message
{
    [self raiseIncompatibilityException];
}

#pragma mark Incompatible Rules

- (void)raiseIncompatibilityException
{
    [NSException raise:@"AJWValidator Error"
                format:@"Attempted to add validation rule that is not compatible for validator type %@, %s", NSStringFromAJWValidatorType(self.type), __PRETTY_FUNCTION__];
}

#pragma mark Validate

- (BOOL)isValid
{
    return (self.state == AJWValidatorValidationStateValid);
}

- (void)validate:(id)instance
{
    [self ajwValidate:instance];
}

- (void)ajwValidate:(id)instance
{
    [self ajwValidate:instance
           parameters:nil];
}

- (void)validate:(id)instance parameters:(NSDictionary *)parameters
{
    [self ajwValidate:instance
           parameters:parameters];
}

- (void)ajwValidate:(id)instance
         parameters:(NSDictionary *)parameters
{
    [self clearErrorMessages];
    
    self.localConditionsSatisfied = YES;
    
    __block AJWValidatorState newState = AJWValidatorValidationStateValid;
    
    [self.rules enumerateObjectsUsingBlock:^(AJWValidatorRule *rule, NSUInteger idx, BOOL *stop) {
        
        switch (rule.type) {
                
            case AJWValidatorRuleTypeRemote: {
                
                AJWValidatorRemoteRule *remoteRule = (AJWValidatorRemoteRule *)rule;
                [self addErrorMessageForRule:rule];
                newState = AJWValidatorValidationStateWaitingForRemote;
                [remoteRule startRequestToValidateInstance:instance
                                                withParams:parameters];
                break;
            
            }
                
            default: {
                
                if (![rule isValidationRuleSatisfied:instance]) {
                    [self addErrorMessageForRule:rule];
                    self.localConditionsSatisfied = NO;
                    newState = AJWValidatorValidationStateInvalid;
                }
                
                break;
            }
                
        }
        
    }];
    
    self.state = newState;
}

#pragma mark State Change

- (void)setState:(AJWValidatorState)state
{
    _state = state;
    
    if (self.validatorStateChangedHandler) {
        self.validatorStateChangedHandler(state);
    }
}

#pragma mark Messages

- (NSArray *)errorMessages
{
    return [NSArray arrayWithArray:self.mutableErrorMessages];
}

- (void)addErrorMessageForRule:(AJWValidatorRule *)rule
{
    [self.mutableErrorMessages addObject:rule.errorMessage];
}

- (void)clearErrorMessages
{
    [self.mutableErrorMessages removeAllObjects];
}

- (void)removeValidationMessage:(NSString *)message
{
    [self.mutableErrorMessages removeObjectIdenticalTo:message];
}

#pragma mark Utilty

- (NSUInteger)ruleCount
{
    return [self.rules count];
}

@end