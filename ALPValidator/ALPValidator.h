/*
 
 ALPValidator.h
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

#import <Foundation/Foundation.h>

@class ALPValidator;

typedef NS_ENUM(NSUInteger, ALPValidatorType) {
    ALPValidatorTypeString,
    ALPValidatorTypeNumeric
};

typedef NS_ENUM(NSUInteger, ALPValidatorState) {
    ALPValidatorValidationStateInvalid,
    ALPValidatorValidationStateValid,
    ALPValidatorValidationStateWaitingForRemote
};

typedef void (^ALPValidatorStateChangeHandler)(ALPValidatorState);
typedef BOOL (^ALPValidatorCustomRuleBlock)(id);

extern NSString * const ALPValidatorRegularExpressionPatternEmail;

@protocol ALPValidatorDelegate <NSObject>

@optional
- (void)validator:(ALPValidator *)validator remoteValidationAtURL:(NSURL *)url receivedResult:(BOOL)remoteConditionValid;
- (void)validator:(ALPValidator *)validator remoteValidationAtURL:(NSURL *)url failedWithError:(NSError *)error;

@end

@interface ALPValidator : NSObject

@property (weak, nonatomic) id <ALPValidatorDelegate> delegate;
@property (copy, nonatomic) ALPValidatorStateChangeHandler validatorStateChangedHandler;

@property (nonatomic, readonly) ALPValidatorState state;
@property (readonly) NSUInteger ruleCount;
@property (copy, nonatomic, readonly) NSArray *errorMessages;

+ (instancetype)validatorWithType:(ALPValidatorType)type;

- (void)addValidationToEnsurePresenceWithInvalidMessage:(NSString *)message;
- (void)addValidationToEnsureMinimumLength:(NSUInteger)minLength invalidMessage:(NSString *)message;
- (void)addValidationToEnsureMaximumLength:(NSUInteger)maxLength invalidMessage:(NSString *)message;
- (void)addValidationToEnsureRangeWithMinimum:(NSNumber *)min maximum:(NSNumber *)max invalidMessage:(NSString *)message;
- (void)addValidationToEnsureInstanceIsTheSameAs:(id)otherInstance invalidMessage:(NSString *)message;
- (void)addValidationToEnsureRegularExpressionIsMetWithPattern:(NSString *)pattern invalidMessage:(NSString *)message;
- (void)addValidationToEnsureValidEmailWithInvalidMessage:(NSString *)message;
- (void)addValidationToEnsureRemoteConditionIsSatisfiedAtURL:(NSURL *)url invalidMessage:(NSString *)message;
- (void)addValidationToEnsureCustomConditionIsSatisfiedWithBlock:(ALPValidatorCustomRuleBlock)block invalidMessage:(NSString *)message;
- (void)validate:(id)instance;
- (void)validate:(id)instance parameters:(NSDictionary *)parameters;
- (BOOL)isValid;

@end