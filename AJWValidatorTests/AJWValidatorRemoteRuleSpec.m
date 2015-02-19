#import "Kiwi.h"
#import "ALPValidator.h"
#import "OHHTTPStubs.h"

SPEC_BEGIN(ALPValidatorRemoteRuleSpecSpec)

describe(@"ALPValidatorRemoteRuleSpec", ^{
    
    NSURL *service = [NSURL URLWithString:@"http://app-back-end.com/validate"];
    __block id delegateMock = [KWMock mockForProtocol:@protocol(ALPValidatorDelegate)];
    
    __block ALPValidator *stringValidator;
    __block ALPValidator *numericValidator;
    
    beforeEach(^{
        stringValidator = [ALPValidator validatorWithType:ALPValidatorTypeString];
        numericValidator = [ALPValidator validatorWithType:ALPValidatorTypeNumeric];
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

SPEC_END
