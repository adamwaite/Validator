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
#import "ALPStringValidator.h"
#import "ALPNumberValidator.h"

SPEC_BEGIN(ALPValidatorSpec)

describe(@"ALPValidator", ^{
    
    describe(@"initialiser", ^{
        
        __block id subject;
        
        context(@"not using the designated initialiser", ^{
            specify(^{
                [[theBlock(^{ subject = [[ALPValidator alloc] init]; }) should] raise];
            });
        });
        
        context(@"passing string type to designated initialiser", ^{
            beforeEach(^{
                subject = [ALPValidator validatorWithType:ALPValidatorTypeString];
            });
            specify(^{
                [[subject should] beKindOfClass:[ALPStringValidator class]];
            });
        });

        context(@"passing numberic type to designated initialiser", ^{
            beforeEach(^{
                subject = [ALPValidator validatorWithType:ALPValidatorTypeNumeric];
            });
            specify(^{
                [[subject should] beKindOfClass:[ALPNumberValidator class]];
            });
        });
        
    });
    
    describe(@"string validator rules", ^{
        
        __block ALPValidator *subject;
        
        beforeEach(^{
            subject = [ALPValidator validatorWithType:ALPValidatorTypeString];
        });
        
        afterEach(^{
            subject = nil;
        });
        
        describe(@"required", ^{
            
            beforeEach(^{
                [subject addValidationToEnsurePresenceWithInvalidMessage:nil];
            });
            
            context(@"passing nil", ^{
                [subject validate:nil];
                specify(^{
                    [[theValue(subject.state) should] equal:theValue(ALPValidatorValidationStateInvalid)];
                });
            });
            
            context(@"passing empty string", ^{
                beforeEach(^{
                    [subject validate:@""];
                });
                specify(^{
                    [[theValue(subject.state) should] equal:theValue(ALPValidatorValidationStateInvalid)];
                });
            });
            
            context(@"passing valid string", ^{
                beforeEach(^{
                    [subject validate:@"hello"];
                });
                specify(^{
                    [[theValue(subject.state) should] equal:theValue(ALPValidatorValidationStateValid)];
                });
            });
            
        });
        
        
        describe(@"minimum length", ^{
            
            beforeEach(^{
                [subject addValidationToEnsureMinimumLength:3 invalidMessage:nil];
            });
            
            context(@"failing to satisfy the minimum length condition", ^{
                beforeEach(^{
                    [subject validate:@"ab"];
                });
                specify(^{
                    [[theValue(subject.state) should] equal:theValue(ALPValidatorValidationStateInvalid)];
                });
            });
            
            context(@"satisfying the minimum length condition", ^{
                beforeEach(^{
                    [subject validate:@"abcd"];
                });
                specify(^{
                    [[theValue(subject.state) should] equal:theValue(ALPValidatorValidationStateValid)];
                });
            });
            
        });
        
        describe(@"maximum length", ^{
            
            beforeEach(^{
                [subject addValidationToEnsureMaximumLength:5 invalidMessage:nil];
            });
            
            context(@"exceeding the maximum length condition", ^{
                beforeEach(^{
                    [subject validate:@"abcdef"];
                });
                specify(^{
                    [[theValue(subject.state) should] equal:theValue(ALPValidatorValidationStateInvalid)];
                });
            });
            
            context(@"satisfying the maximum length condition", ^{
                beforeEach(^{
                    [subject validate:@"abc"];
                });
                specify(^{
                    [[theValue(subject.state) should] equal:theValue(ALPValidatorValidationStateValid)];
                });
            });
            
        });
        
        describe(@"regular expression", ^{
        
            NSString *pattern = @"hello";
            NSString *invalid = @"hey";
        
            beforeEach(^{
                [subject addValidationToEnsureRegularExpressionIsMetWithPattern:pattern invalidMessage:nil];
            });
            
            context(@"input does not satisfy the regular expression", ^{
                beforeEach(^{
                    [subject validate:invalid];
                });
                specify(^{
                    [[theValue(subject.state) should] equal:theValue(ALPValidatorValidationStateInvalid)];
                });
            });
            
            context(@"input satisfies the regular expression", ^{
                beforeEach(^{
                    [subject validate:pattern];
                });
                specify(^{
                    [[theValue(subject.state) should] equal:theValue(ALPValidatorValidationStateValid)];
                });
            });
            
        });
        
        describe(@"email", ^{
            
            NSArray *invalidEmailAddresses = @[@"user@invalid,com", @"userinvalid.com", @"invalid", @"user@invalid@example.com", @"user@in+valid.com"];
            NSString *validEmailAddress = @"user@valid.com";
            
            beforeEach(^{
                [subject addValidationToEnsureValidEmailWithInvalidMessage:nil];
            });
            
            context(@"with invalid email addresses", ^{
                it(@"should be invalid", ^{
                    [invalidEmailAddresses enumerateObjectsUsingBlock:^(NSString *invalidEmailAddress, NSUInteger idx, BOOL *stop) {
                        [subject validate:invalidEmailAddress];
                        [[theValue(subject.state) should] equal:theValue(ALPValidatorValidationStateInvalid)];
                    }];
                });
            });
            
            context(@"with a valid email address", ^{
                beforeEach(^{
                    [subject validate:validEmailAddress];
                });
                specify(^{
                    [[theValue(subject.state) should] equal:theValue(ALPValidatorValidationStateValid)];
                });
            });
            
        });
        
        describe(@"custom", ^{
            
            ALPValidatorCustomRuleBlock noLetterACustomRule = ^BOOL(NSString *instance){
                return ([instance rangeOfString:@"A"].location == NSNotFound);
            };
            
            beforeEach(^{
                [subject addValidationToEnsureCustomConditionIsSatisfiedWithBlock:noLetterACustomRule invalidMessage:nil];
            });
            
            context(@"custom condition is not satisfied", ^{
                beforeEach(^{
                    [subject validate:@"hAllo"];
                });
                specify(^{
                    [[theValue(subject.state) should] equal:theValue(ALPValidatorValidationStateInvalid)];
                });
            });
            
            context(@"custom condition is satisfied", ^{
                beforeEach(^{
                    [subject validate:@"hello"];
                });
                specify(^{
                    [[theValue(subject.state) should] equal:theValue(ALPValidatorValidationStateValid)];
                });
            });
            
        });
        
        describe(@"remote service validation", ^{
            
            NSURL *service = [NSURL URLWithString:@"http://app-back-end.com/validate"];
            __block id delegateMock = [KWMock mockForProtocol:@protocol(ALPValidatorDelegate)];
            
            beforeEach(^{
                [subject addValidationToEnsureRemoteConditionIsSatisfiedAtURL:service invalidMessage:nil];
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
                        [subject validate:@"any"];
                    });
                    specify(^{
                        [[theValue(subject.state) should] equal:theValue(ALPValidatorValidationStateWaitingForRemote)];
                    });
                    specify(^{
                        [[expectFutureValue(theValue(subject.state)) shouldEventually] equal:theValue(ALPValidatorValidationStateInvalid)];
                    });
                });
                
                describe(@"delegate", ^{
                    beforeEach(^{
                        subject.delegate = delegateMock;
                    });
                    it(@"should be notified", ^{
                        [[delegateMock shouldEventually] receive:@selector(validator:remoteValidationAtURL:receivedResult:)];
                        [subject validate:@"any"];
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
                        [subject validate:@"any"];
                    });
                    specify(^{
                        [[expectFutureValue(theValue(subject.state)) shouldEventually] equal:theValue(ALPValidatorValidationStateValid)];
                    });
                });
                
                describe(@"delegate", ^{
                    beforeEach(^{
                        subject.delegate = delegateMock;
                    });
                    it(@"should be notified", ^{
                        [[delegateMock shouldEventually] receive:@selector(validator:remoteValidationAtURL:receivedResult:)];
                        [subject validate:@"any"];
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
                        [subject validate:@"any"];
                    });
                    specify(^{
                        [[expectFutureValue(theValue(subject.state)) shouldEventually] equal:theValue(ALPValidatorValidationStateInvalid)];
                    });
                });
                
                describe(@"delegate", ^{
                    beforeEach(^{
                        subject.delegate = delegateMock;
                    });
                    it(@"should be notified", ^{
                        [[delegateMock shouldEventually] receive:@selector(validator:remoteValidationAtURL:receivedResult:)];
                        [subject validate:@"any"];
                    });
                });
                
            });
            
        });
        
    });
    
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
                specify(^{
                    [subject addValidationToEnsureMinimumLength:4 invalidMessage:@"string not long enough"];
                    [subject validate:@"abcde"];
                    [[theValue([subject.errorMessages count]) should] equal:theValue(0)];
                });
            });
            
        });
        
        context(@"when invalid", ^{
            
            context(@"default messages (nil passed with rule)", ^{
                specify(^{
                    [subject addValidationToEnsureMinimumLength:4 invalidMessage:nil];
                    [subject validate:@"abc"];
                    [[theValue([subject.errorMessages count]) should] equal:theValue(1)];
                });
            });

            context(@"rule supplied with validation add", ^{
                NSString *errorMessage = @"that's not an email address, silly user";
                specify(^{
                    [subject addValidationToEnsureValidEmailWithInvalidMessage:errorMessage];
                    [subject validate:@"inv@lid,co,uk"];
                    [[theValue([subject.errorMessages count]) should] equal:theValue(1)];
                    [[[subject.errorMessages lastObject] should] equal:errorMessage];
                });
            });
            
            describe(@"errors clear when changed", ^{
                specify(^{
                    [subject addValidationToEnsureValidEmailWithInvalidMessage:nil];
                    [subject validate:@"inv@lid,co,uk"];
                    [[theValue([subject.errorMessages count]) should] equal:theValue(1)];
                    [subject validate:@"inv@lid.co.uk"];
                    [[theValue([subject.errorMessages count]) should] equal:theValue(0)];
                });
            });
            
        });
        
    });
    
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
        });
        
        afterEach(^{
            subject = nil;
        });
        
        specify(^{
            [[theValue(thingToWatch) should] equal:theValue(0)];
        });
        
        specify(^{
            [subject validate:@"valid"];
            [[theValue(thingToWatch) should] equal:theValue(1)];
        });
        
    });
    
});

SPEC_END
