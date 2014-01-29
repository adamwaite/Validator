/*
 
 ALPValidator.m
 ALPValidator
 
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

#import "ALPValidator.h"
#import "ALPStringValidator.h"
#import "ALPNumberValidator.h"
#import "ALPValidatorRule.h"
#import "ALPValidatorRequiredRule.h"
#import "ALPValidatorMinimumLengthRule.h"
#import "ALPValidatorMaximumLengthRule.h"
#import "ALPValidatorRegularExpressionRule.h"
#import "ALPValidatorRemoteRule.h"
#import "ALPValidatorCustomRule.h"

const NSString * NSStringFromALPValidatorState(ALPValidatorState state) {
    switch (state) {
        case ALPValidatorValidationStateInvalid: return @"Invalid";
        case ALPValidatorValidationStateValid: return @"Valid";
        case ALPValidatorValidationStateWaitingForRemote: return @"Waiting for remote validation";
        default: return nil;
    }
}

NSString * const ALPValidatorRegularExpressionPatternEmail = @"^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-+]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z‌​]{2,4})$";

@interface ALPValidator ()

@property (nonatomic) ALPValidatorType type;
@property (nonatomic) ALPValidatorState state;
@property (strong, nonatomic) NSMutableArray *rules;
@property (nonatomic) BOOL localConditionsSatisfied;
@property (copy, nonatomic) NSArray *errorMessages;
@property (copy, nonatomic) NSMutableArray *mutableErrorMessages;

@end

@implementation ALPValidator

#pragma mark Init

+ (instancetype)validatorWithType:(ALPValidatorType)type
{
    switch (type) {
        case (ALPValidatorTypeString):
            return [[ALPStringValidator alloc] initWithType:type];
        case (ALPValidatorTypeNumeric): {
            return [[ALPNumberValidator alloc] initWithType:type];
        }
    }
}

- (id)init
{
    [NSException raise:@"ALPStringValidator" format:@"Use the designated initialiser (%@) to create validators, %s", NSStringFromSelector(@selector(validatorWithType:)), __PRETTY_FUNCTION__];
    return nil;
}

- (id)initWithType:(ALPValidatorType)type
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
    NSDictionary *output = @{
        @"_state": @(_state),
        @"state as string": NSStringFromALPValidatorState(_state),
        @"errorMessages": _errorMessages
    };
    
    return [NSString stringWithFormat:@"%@ %p: %@", [self class], self, output];
}

- (NSString *)debugDescription
{
    return [self description];
}

#pragma mark Rule Add/Remove Rules

- (void)addValidationToEnsurePresenceWithInvalidMessage:(NSString *)message
{
    ALPValidatorRequiredRule *rule = [[ALPValidatorRequiredRule alloc] initWithType:ALPValidatorRuleTypeRequired invalidMessage:message];
    [_rules addObject:rule];
}

- (void)addValidationToEnsureMinimumLength:(NSUInteger)minLength invalidMessage:(NSString *)message
{
    ALPValidatorMinimumLengthRule *rule = [[ALPValidatorMinimumLengthRule alloc] initWithType:ALPValidatorRuleTypeMinLength invalidMessage:message minLength:minLength];
    [_rules addObject:rule];
}

- (void)addValidationToEnsureMaximumLength:(NSUInteger)maxLength invalidMessage:(NSString *)message
{
    ALPValidatorMaximumLengthRule *rule = [[ALPValidatorMaximumLengthRule alloc] initWithType:ALPValidatorRuleTypeMaxLength invalidMessage:message maxLength:maxLength];
    [_rules addObject:rule];
}

- (void)addValidationToEnsureRegularExpressionIsMetWithPattern:(NSString *)pattern invalidMessage:(NSString *)message
{
    ALPValidatorRegularExpressionRule *rule = [[ALPValidatorRegularExpressionRule alloc] initWithType:ALPValidatorRuleTypeTypeRegex invalidMessage:message pattern:pattern];
    [_rules addObject:rule];
}

- (void)addValidationToEnsureValidEmailWithInvalidMessage:(NSString *)message
{
    ALPValidatorRegularExpressionRule *rule = [[ALPValidatorRegularExpressionRule alloc] initWithType:ALPValidatorRuleTypeTypeEmail invalidMessage:message pattern:ALPValidatorRegularExpressionPatternEmail];
    [_rules addObject:rule];
}

- (void)addValidationToEnsureCustomConditionIsSatisfiedWithBlock:(ALPValidatorCustomRuleBlock)block invalidMessage:(NSString *)message
{
    ALPValidatorCustomRule *rule = [[ALPValidatorCustomRule alloc] initWithType:ALPValidatorRuleTypeCustom block:block invalidMessage:message];
    [_rules addObject:rule];
}

- (void)addValidationToEnsureRemoteConditionIsSatisfiedAtURL:(NSURL *)url invalidMessage:(NSString *)message
{
    
    __typeof__(self) __weak weakSelf = self;
    
    ALPValidatorRemoteRule *rule = [[ALPValidatorRemoteRule alloc] initWithType:ALPValidatorRuleTypeTypeRemote serviceURL:(NSURL *)url invalidMessage:message completionHandler:^(BOOL remoteConditionSatisfied, NSError *error) {
        
        if (!error) {
            
            if (remoteConditionSatisfied) {
                
                [weakSelf removeValidationMessage:message];
                
                if (weakSelf.localConditionsSatisfied) {
                    weakSelf.state = ALPValidatorValidationStateValid;
                }
                else {
                    weakSelf.state = ALPValidatorValidationStateInvalid;
                }
            
            }
            else {
                weakSelf.state = ALPValidatorValidationStateInvalid;
            }
            
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(validator:remoteValidationAtURL:receivedResult:)]) {
                [weakSelf.delegate validator:self remoteValidationAtURL:url receivedResult:remoteConditionSatisfied];
            }
            
        }
        else {
            
            weakSelf.state = ALPValidatorValidationStateInvalid;
            
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(validator:remoteValidationAtURL:failedWithError:)]) {
                [weakSelf.delegate validator:self remoteValidationAtURL:url failedWithError:error];
            }
        
        }
        
    }];
    
    [_rules addObject:rule];
}

#pragma mark Validate

- (BOOL)isValid
{
    return (_state == ALPValidatorValidationStateValid);
}

- (void)validate:(id)instance
{
    [self validate:instance parameters:nil];
}

- (void)validate:(id)instance parameters:(NSDictionary *)parameters
{

    [self clearErrorMessages];
    
    self.state = ALPValidatorValidationStateValid;
    self.localConditionsSatisfied = YES;
    
    [_rules enumerateObjectsUsingBlock:^(ALPValidatorRule *rule, NSUInteger idx, BOOL *stop) {
        
        switch (rule.type) {
            
            case ALPValidatorRuleTypeTypeRemote: {
                ALPValidatorRemoteRule *remoteRule = (ALPValidatorRemoteRule *)rule;
                self.state = ALPValidatorValidationStateWaitingForRemote;
                [self addErrorMessageForRule:rule];
                [remoteRule startRequestToValidateInstance:instance withParams:parameters];
                break;
            }
                
            default: {
                if (![rule isValidationRuleSatisfied:instance]) {
                    self.state = ALPValidatorValidationStateInvalid;
                    self.localConditionsSatisfied = NO;
                    [self addErrorMessageForRule:rule];
                }
                break;
            }
            
        }
        
    }];
    
    [self updatePublicErrorMessages];
    
}

#pragma mark State Change

- (void)setState:(ALPValidatorState)state
{
    if (_state != state) {
        _state = state;
        if (_validatorStateChangedHandler) {
            _validatorStateChangedHandler(_state);
        }
    }
}

#pragma mark Messages

- (void)addErrorMessageForRule:(ALPValidatorRule *)rule
{
    [_mutableErrorMessages addObject:rule.errorMessage];
}

- (void)clearErrorMessages
{
    [_mutableErrorMessages removeAllObjects];
}

- (void)removeValidationMessage:(NSString *)message
{
    [_mutableErrorMessages removeObjectIdenticalTo:message];
    [self updatePublicErrorMessages];
}

- (void)updatePublicErrorMessages
{
    self.errorMessages = [NSArray arrayWithArray:_mutableErrorMessages];
}

@end