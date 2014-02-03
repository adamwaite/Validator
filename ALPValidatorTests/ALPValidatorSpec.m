/*
 
 ALPValidatorSpec.m
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

#import "Kiwi.h"
#import "OHHTTPStubs.h"

#import "ALPValidator.h"

SPEC_BEGIN(ALPValidatorSpec)

describe(@"ALPValidator", ^{

    #pragma mark Initialiser Specs
    
    describe(@"initialiser", ^{
        
        __block id subject;
        
        context(@"not using the designated initialiser", ^{
            specify(^{
                [[theBlock(^{ subject = [[ALPValidator alloc] init]; }) should] raise];
            });
        });
        
        context(@"using the designated initialiser", ^{
            beforeEach(^{
                subject = [ALPValidator validatorWithType:ALPValidatorTypeString];
            });
            specify(^{
                [[subject should] beKindOfClass:[ALPValidator class]];
            });
        });
        
    });
    
    #pragma mark Validator Rule Specs
    
    describe(@"validator rules", ^{
        
        __block ALPValidator *stringValidator;
        __block ALPValidator *numericValidator;
        
        beforeEach(^{
            stringValidator = [ALPValidator validatorWithType:ALPValidatorTypeString];
            numericValidator = [ALPValidator validatorWithType:ALPValidatorTypeNumeric];
        });
        
        afterEach(^{
            stringValidator = nil;
            numericValidator = nil;
        });
        
        #pragma mark Required Rule Specs
        
        describe(@"presence", ^{
            
            beforeEach(^{
                [stringValidator addValidationToEnsurePresenceWithInvalidMessage:nil];
            });
            
            specify(^{
                [[theValue(stringValidator.ruleCount) should] equal:theValue(1)];
            });
            
            specify(^{
                [[theBlock(^{
                    [numericValidator addValidationToEnsurePresenceWithInvalidMessage:nil];
                }) should] raise];
            });
            
            context(@"passing nil", ^{
                [stringValidator validate:nil];
                [numericValidator validate:nil];
                specify(^{
                    [[theValue(stringValidator.state) should] equal:theValue(ALPValidatorValidationStateInvalid)];
                });
            });
            
            context(@"passing empty string", ^{
                beforeEach(^{
                    [stringValidator validate:@""];
                });
                specify(^{
                    [[theValue(stringValidator.state) should] equal:theValue(ALPValidatorValidationStateInvalid)];
                });
            });
            
            context(@"passing valid string", ^{
                beforeEach(^{
                    [stringValidator validate:@"hello"];
                });
                specify(^{
                    [[theValue(stringValidator.state) should] equal:theValue(ALPValidatorValidationStateValid)];
                });
            });
            
        });
        
        #pragma mark Minimum Length Rule Specs
        
        describe(@"minimum length", ^{
            
            beforeEach(^{
                [stringValidator addValidationToEnsureMinimumLength:3 invalidMessage:nil];
            });
            
            specify(^{
                [[theValue(stringValidator.ruleCount) should] equal:theValue(1)];
            });
            
            specify(^{
                [[theBlock(^{
                    [numericValidator addValidationToEnsurePresenceWithInvalidMessage:nil];
                }) should] raise];
            });
            
            context(@"failing to satisfy the minimum length condition", ^{
                beforeEach(^{
                    [stringValidator validate:@"ab"];
                });
                specify(^{
                    [[theValue(stringValidator.state) should] equal:theValue(ALPValidatorValidationStateInvalid)];
                });
            });
            
            context(@"satisfying the minimum length condition", ^{
                beforeEach(^{
                    [stringValidator validate:@"abcd"];
                });
                specify(^{
                    [[theValue(stringValidator.state) should] equal:theValue(ALPValidatorValidationStateValid)];
                });
            });
            
        });
        
        #pragma mark Maximum Length Rule Specs
        
        describe(@"maximum length", ^{
            
            beforeEach(^{
                [stringValidator addValidationToEnsureMaximumLength:5 invalidMessage:nil];
            });
            
            specify(^{
                [[theValue(stringValidator.ruleCount) should] equal:theValue(1)];
            });
            
            specify(^{
                [[theBlock(^{
                    [numericValidator addValidationToEnsurePresenceWithInvalidMessage:nil];
                }) should] raise];
            });
            
            context(@"exceeding the maximum length condition", ^{
                beforeEach(^{
                    [stringValidator validate:@"abcdef"];
                });
                specify(^{
                    [[theValue(stringValidator.state) should] equal:theValue(ALPValidatorValidationStateInvalid)];
                });
            });
            
            context(@"satisfying the maximum length condition", ^{
                beforeEach(^{
                    [stringValidator validate:@"abc"];
                });
                specify(^{
                    [[theValue(stringValidator.state) should] equal:theValue(ALPValidatorValidationStateValid)];
                });
            });
            
        });
        
        describe(@"range rule spec", ^{
            
            beforeEach(^{
                [stringValidator addValidationToEnsureRangeWithMinimum:@3 maximum:@10 invalidMessage:nil];
                [numericValidator addValidationToEnsureRangeWithMinimum:@3 maximum:@10 invalidMessage:nil];
            });
            
            specify(^{
                [[theValue(stringValidator.ruleCount) should] equal:theValue(1)];
            });
            
            specify(^{
                [[theValue(numericValidator.ruleCount) should] equal:theValue(1)];
            });
            
            context(@"string that is too short", ^{
                beforeEach(^{
                    [stringValidator validate:@"ab"];
                });
                specify(^{
                    [[theValue(stringValidator.state) should] equal:theValue(ALPValidatorValidationStateInvalid)];
                });
            });
            
            context(@"string that is too long", ^{
                beforeEach(^{
                    [stringValidator validate:@"abcdefghijklmnop"];
                });
                specify(^{
                    [[theValue(stringValidator.state) should] equal:theValue(ALPValidatorValidationStateInvalid)];
                });
            });
            
            context(@"string that is within the character range", ^{
                beforeEach(^{
                    [stringValidator validate:@"abcde"];
                });
                specify(^{
                    [[theValue(stringValidator.state) should] equal:theValue(ALPValidatorValidationStateValid)];
                });
            });
            
            context(@"number that is too small", ^{
                beforeEach(^{
                    [numericValidator validate:@2.999];
                });
                specify(^{
                    [[theValue(numericValidator.state) should] equal:theValue(ALPValidatorValidationStateInvalid)];
                });
            });
            
            context(@"number that is too big", ^{
                beforeEach(^{
                    [numericValidator validate:@10.001];
                });
                specify(^{
                    [[theValue(numericValidator.state) should] equal:theValue(ALPValidatorValidationStateInvalid)];
                });
            });
            
            context(@"number that is within range", ^{
                beforeEach(^{
                    [numericValidator validate:@5];
                });
                specify(^{
                    [[theValue(numericValidator.state) should] equal:theValue(ALPValidatorValidationStateValid)];
                });
            });
            
        });
        
        #pragma mark Equal Validation
        
        describe(@"is same as validation", ^{
            
            beforeEach(^{
                [stringValidator addValidationToEnsureInstanceIsTheSameAs:@"p4ssword" invalidMessage:nil];
                [numericValidator addValidationToEnsureInstanceIsTheSameAs:@5 invalidMessage:nil];
            });
            
            specify(^{
                [[theValue(stringValidator.ruleCount) should] equal:theValue(1)];
            });
            
            specify(^{
                [[theValue(numericValidator.ruleCount) should] equal:theValue(1)];
            });
            
            context(@"unequal strings", ^{
                beforeEach(^{
                    [stringValidator validate:@"password"];
                });
                specify(^{
                    [[theValue(stringValidator.state) should] equal:theValue(ALPValidatorValidationStateInvalid)];
                });
            });
            
            context(@"equal strings", ^{
                beforeEach(^{
                    [stringValidator validate:@"p4ssword"];
                });
                specify(^{
                    [[theValue(stringValidator.state) should] equal:theValue(ALPValidatorValidationStateValid)];
                });
            });
            
            context(@"unequal numbers", ^{
                beforeEach(^{
                    [numericValidator validate:@4.9];
                });
                specify(^{
                    [[theValue(numericValidator.state) should] equal:theValue(ALPValidatorValidationStateInvalid)];
                });
            });
            
            context(@"equal numbers", ^{
                beforeEach(^{
                    [numericValidator validate:@5];
                });
                specify(^{
                    [[theValue(numericValidator.state) should] equal:theValue(ALPValidatorValidationStateValid)];
                });
            });
            
            describe(@"changing string", ^{
                
                ALPValidator *textFieldValidator = [ALPValidator validatorWithType:ALPValidatorTypeString];
                NSMutableString *changingString = [NSMutableString string];
                changingString = [NSMutableString stringWithString:@"hey"];
                
                beforeEach(^{
                    [textFieldValidator addValidationToEnsureInstanceIsTheSameAs:changingString invalidMessage:nil];
                    [textFieldValidator validate:@"hey"];
                });
                
                specify(^{
                    [[theValue(textFieldValidator.state) should] equal:theValue(ALPValidatorValidationStateValid)];
                });
                
                context(@"when the string chnages", ^{
                    beforeEach(^{
                        [changingString appendString:@"a"];
                        [textFieldValidator validate:@"hey"];
                    });
                    specify(^{
                        [[theValue(textFieldValidator.state) shouldNot] equal:theValue(ALPValidatorValidationStateValid)];
                    });
                });
                
            });
            
        });
        
        #pragma mark Regex Rule Specs
        
        describe(@"regular expression", ^{
        
            NSString *pattern = @"hello";
            NSString *invalid = @"hey";
        
            beforeEach(^{
                [stringValidator addValidationToEnsureRegularExpressionIsMetWithPattern:pattern invalidMessage:nil];
            });
            
            specify(^{
                [[theValue(stringValidator.ruleCount) should] equal:theValue(1)];
            });
            
            specify(^{
                [[theBlock(^{
                    [numericValidator addValidationToEnsurePresenceWithInvalidMessage:nil];
                }) should] raise];
            });
            
            context(@"input does not satisfy the regular expression", ^{
                beforeEach(^{
                    [stringValidator validate:invalid];
                });
                specify(^{
                    [[theValue(stringValidator.state) should] equal:theValue(ALPValidatorValidationStateInvalid)];
                });
            });
            
            context(@"input satisfies the regular expression", ^{
                beforeEach(^{
                    [stringValidator validate:pattern];
                });
                specify(^{
                    [[theValue(stringValidator.state) should] equal:theValue(ALPValidatorValidationStateValid)];
                });
            });
            
        });
        
        #pragma mark Email Rule Specs
        
        describe(@"email", ^{
            
            NSArray *invalidEmailAddresses = @[@"user@invalid,com", @"userinvalid.com", @"invalid", @"user@invalid@example.com", @"user@in+valid.com"];
            NSString *validEmailAddress = @"user@valid.com";
            
            beforeEach(^{
                [stringValidator addValidationToEnsureValidEmailWithInvalidMessage:nil];
            });
            
            specify(^{
                [[theValue(stringValidator.ruleCount) should] equal:theValue(1)];
            });
            
            specify(^{
                [[theBlock(^{
                    [numericValidator addValidationToEnsurePresenceWithInvalidMessage:nil];
                }) should] raise];
            });
            
            context(@"with invalid email addresses", ^{
                it(@"should be invalid", ^{
                    [invalidEmailAddresses enumerateObjectsUsingBlock:^(NSString *invalidEmailAddress, NSUInteger idx, BOOL *stop) {
                        [stringValidator validate:invalidEmailAddress];
                        [[theValue(stringValidator.state) should] equal:theValue(ALPValidatorValidationStateInvalid)];
                    }];
                });
            });
            
            context(@"with a valid email address", ^{
                beforeEach(^{
                    [stringValidator validate:validEmailAddress];
                });
                specify(^{
                    [[theValue(stringValidator.state) should] equal:theValue(ALPValidatorValidationStateValid)];
                });
            });
            
        });
        
        #pragma mark Custom Rule Specs
        
        describe(@"custom", ^{
            
            ALPValidatorCustomRuleBlock noLetterACustomRule = ^BOOL(NSString *instance){
                return ([instance rangeOfString:@"A"].location == NSNotFound);
            };
            
            ALPValidatorCustomRuleBlock numberIsFive = ^BOOL(NSNumber *instance){
                return ([instance isEqual:@5]);
            };
            
            beforeEach(^{
                [stringValidator addValidationToEnsureCustomConditionIsSatisfiedWithBlock:noLetterACustomRule invalidMessage:nil];
                [numericValidator addValidationToEnsureCustomConditionIsSatisfiedWithBlock:numberIsFive invalidMessage:nil];
            });
            
            specify(^{
                [[theValue(stringValidator.ruleCount) should] equal:theValue(1)];
            });
            
            specify(^{
                [[theValue(numericValidator.ruleCount) should] equal:theValue(1)];
            });
            
            context(@"custom condition is not satisfied", ^{
                beforeEach(^{
                    [stringValidator validate:@"hAllo"];
                    [numericValidator validate:@1];
                });
                specify(^{
                    [[theValue(stringValidator.state) should] equal:theValue(ALPValidatorValidationStateInvalid)];
                });
                specify(^{
                    [[theValue(numericValidator.state) should] equal:theValue(ALPValidatorValidationStateInvalid)];
                });
            });
            
            context(@"custom condition is satisfied", ^{
                beforeEach(^{
                    [stringValidator validate:@"hello"];
                    [numericValidator validate:@5];
                });
                specify(^{
                    [[theValue(stringValidator.state) should] equal:theValue(ALPValidatorValidationStateValid)];
                });
                specify(^{
                    [[theValue(numericValidator.state) should] equal:theValue(ALPValidatorValidationStateValid)];
                });
            });
            
        });
        
        #pragma mark Remote Rule Specs
        
        describe(@"remote service validation", ^{
            
            NSURL *service = [NSURL URLWithString:@"http://app-back-end.com/validate"];
            __block id delegateMock = [KWMock mockForProtocol:@protocol(ALPValidatorDelegate)];
            
            beforeEach(^{
                [stringValidator addValidationToEnsureRemoteConditionIsSatisfiedAtURL:service invalidMessage:nil];
                [numericValidator addValidationToEnsureRemoteConditionIsSatisfiedAtURL:service invalidMessage:nil];
            });
            
            specify(^{
                [[theValue(stringValidator.ruleCount) should] equal:theValue(1)];
            });
            
            specify(^{
                [[theValue(numericValidator.ruleCount) should] equal:theValue(1)];
            });
            
            context(@"service returns false", ^{
                
                beforeEach(^{
                    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                        return YES;
                    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                        NSData *stubFalseResponse = [@"false" dataUsingEncoding:NSUTF8StringEncoding];
                        return [OHHTTPStubsResponse responseWithData:stubFalseResponse statusCode:200 headers:nil];
                    }];
                });
                
                describe(@"state", ^{
                    beforeEach(^{
                        [stringValidator validate:@"any"];
                    });
                    specify(^{
                        [[theValue(stringValidator.state) should] equal:theValue(ALPValidatorValidationStateWaitingForRemote)];
                    });
                    specify(^{
                        [[expectFutureValue(theValue(stringValidator.state)) shouldEventually] equal:theValue(ALPValidatorValidationStateInvalid)];
                    });
                });
                
                describe(@"delegate", ^{
                    beforeEach(^{
                        stringValidator.delegate = delegateMock;
                    });
                    it(@"should be notified", ^{
                        [[delegateMock shouldEventually] receive:@selector(validator:remoteValidationAtURL:receivedResult:)];
                        [stringValidator validate:@"any"];
                    });
                });
                
            });

            context(@"service returns true", ^{
                
                beforeEach(^{
                    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                        return YES;
                    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                        NSData *stubFalseResponse = [@"true" dataUsingEncoding:NSUTF8StringEncoding];
                        return [OHHTTPStubsResponse responseWithData:stubFalseResponse statusCode:200 headers:nil];
                    }];
                });
                
                describe(@"state", ^{
                    beforeEach(^{
                        [stringValidator validate:@"any"];
                    });
                    specify(^{
                        [[expectFutureValue(theValue(stringValidator.state)) shouldEventually] equal:theValue(ALPValidatorValidationStateValid)];
                    });
                });
                
                describe(@"delegate", ^{
                    beforeEach(^{
                        stringValidator.delegate = delegateMock;
                    });
                    it(@"should be notified", ^{
                        [[delegateMock shouldEventually] receive:@selector(validator:remoteValidationAtURL:receivedResult:)];
                        [stringValidator validate:@"any"];
                    });
                });
                
            });
            
            context(@"service fails", ^{
                
                beforeEach(^{
                    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                        return YES;
                    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                        NSData *stubFalseResponse = [@"false" dataUsingEncoding:NSUTF8StringEncoding];
                        return [OHHTTPStubsResponse responseWithData:stubFalseResponse statusCode:200 headers:nil];
                    }];
                });
                
                describe(@"state", ^{
                    beforeEach(^{
                        [stringValidator validate:@"any"];
                    });
                    specify(^{
                        [[expectFutureValue(theValue(stringValidator.state)) shouldEventually] equal:theValue(ALPValidatorValidationStateInvalid)];
                    });
                });
                
                describe(@"delegate", ^{
                    beforeEach(^{
                        stringValidator.delegate = delegateMock;
                    });
                    it(@"should be notified", ^{
                        [[delegateMock shouldEventually] receive:@selector(validator:remoteValidationAtURL:receivedResult:)];
                        [stringValidator validate:@"any"];
                    });
                });
                
            });
            
        });
        
    });
    
    #pragma mark Multiple Validations Specs
    
    describe(@"multiple validation rules", ^{
        
        __block ALPValidator *subject;
        
        beforeEach(^{
            subject = [ALPValidator validatorWithType:ALPValidatorTypeString];
            [subject addValidationToEnsureMinimumLength:5 invalidMessage:nil];
            [subject addValidationToEnsureValidEmailWithInvalidMessage:nil];
            [subject addValidationToEnsureCustomConditionIsSatisfiedWithBlock:^BOOL(NSString *instance) {
                return ([instance rangeOfString:@"A"].location == NSNotFound);
            } invalidMessage:nil];
        });
        
        afterEach(^{
            subject = nil;
        });
        
        specify(^{
            [[theValue(subject.ruleCount) should] equal:theValue(3)];
        });
        
        context(@"invalid", ^{
            beforeEach(^{
                [subject validate:@"hAhA"];
            });
            specify(^{
                [[theValue(subject.state) should] equal:theValue(ALPValidatorValidationStateInvalid)];
            });
            specify(^{
                [[theValue([subject.errorMessages count]) should] equal:theValue(3)];
            });
        });
        
        context(@"failing just one condition", ^{
            beforeEach(^{
                [subject validate:@"Almostvalid@string.com"];
            });
            specify(^{
                [[theValue(subject.state) should] equal:theValue(ALPValidatorValidationStateInvalid)];
            });
            specify(^{
                [[theValue([subject.errorMessages count]) should] equal:theValue(1)];
            });
        });
        
        context(@"valid", ^{
            beforeEach(^{
                [subject validate:@"valid@string.com"];
            });
            specify(^{
                [[theValue(subject.state) should] equal:theValue(ALPValidatorValidationStateValid)];
            });
            specify(^{
                [[theValue([subject.errorMessages count]) should] equal:theValue(0)];
            });
        });
        
    });
    
    #pragma mark Validation Messages Specs
    
    describe(@"Messages", ^{
        
        __block ALPValidator *subject;
        
        beforeEach(^{
            subject = [ALPValidator validatorWithType:ALPValidatorTypeString];
        });
        
        afterEach(^{
            subject = nil;
        });
        
        context(@"when valid", ^{
            
            context(@"no rules", ^{
                specify(^{
                    [[theValue([subject.errorMessages count]) should] equal:theValue(0)];
                });
            });
            
            context(@"with a satisfied rule", ^{
                beforeEach(^{
                    [subject addValidationToEnsureMinimumLength:4 invalidMessage:@"string not long enough"];
                    [subject validate:@"abcde"];
                });
                specify(^{
                    [[theValue([subject.errorMessages count]) should] equal:theValue(0)];
                });
            });
            
        });
        
        context(@"when invalid", ^{
            
            context(@"default messages (nil passed with rule)", ^{
                beforeEach(^{
                    [subject addValidationToEnsureMinimumLength:4 invalidMessage:nil];
                    [subject validate:@"abc"];
                });
                specify(^{
                    [[theValue([subject.errorMessages count]) should] equal:theValue(1)];
                });
            });

            context(@"rule supplied with validation add", ^{
                NSString *errorMessage = @"that's not an email address, silly user";
                beforeEach(^{
                    [subject addValidationToEnsureValidEmailWithInvalidMessage:errorMessage];
                    [subject validate:@"inv@lid,co,uk"];
                });
                specify(^{
                    [[theValue([subject.errorMessages count]) should] equal:theValue(1)];
                });
                specify(^{
                    [[[subject.errorMessages lastObject] should] equal:errorMessage];
                });
            });
            
            describe(@"errors clear when changed", ^{
                beforeEach(^{
                    [subject addValidationToEnsureValidEmailWithInvalidMessage:nil];
                    [subject validate:@"inv@lid,co,uk"];
                    [subject validate:@"inv@lid.co.uk"];
                });
                specify(^{
                    [[theValue([subject.errorMessages count]) should] equal:theValue(0)];
                });
            });
            
        });
        
    });
    
    #pragma mark State Change Handler Specs
    
    describe(@"state change handler", ^{
        
        __block ALPValidator *subject;
        __block NSUInteger thingToWatch = 0;
        
        beforeEach(^{
            subject = [ALPValidator validatorWithType:ALPValidatorTypeString];
            [subject addValidationToEnsurePresenceWithInvalidMessage:nil];
            subject.validatorStateChangedHandler = ^(ALPValidatorState newState) {
                if (newState == ALPValidatorValidationStateValid) {
                    thingToWatch++;
                }
            };
            [subject validate:@"valid"];
        });
        
        afterEach(^{
            subject = nil;
        });
        
        specify(^{
            [[theValue(thingToWatch) should] equal:theValue(1)];
        });
        
    });
    
});

SPEC_END
