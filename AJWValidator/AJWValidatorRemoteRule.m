/*
 
 AJWValidatorRemoteRule.m
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

#import "AJWValidatorRemoteRule.h"

typedef struct {
    BOOL isWaitingForResponse;
    BOOL isValidResponse;
} AJWTextFieldRemoteValidationRuleResponseState;

@interface AJWValidatorRemoteRule ()

@property (strong, nonatomic) NSURL *serviceURL;
@property (nonatomic) AJWTextFieldRemoteValidationRuleResponseState responseState;
@property (copy, nonatomic) AJWValidatorRemoteRuleCompletionHandler requestCompletionHandler;

@end

@implementation AJWValidatorRemoteRule

#pragma mark Init

- (id)initWithType:(AJWValidatorRuleType)type serviceURL:(NSURL *)url invalidMessage:(NSString *)message completionHandler:(AJWValidatorRemoteRuleCompletionHandler)completion
{
    self = [super initWithType:type invalidMessage:message];
    if (self) {
        _serviceURL = url;
        _requestCompletionHandler = completion;
    }
    return self;
}

#pragma mark URLSession

+ (NSURLSession *)validatorSession
{
    static NSURLSession *ValidatorSession = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSURLSessionConfiguration *validatorConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        validatorConfiguration.HTTPAdditionalHeaders = @{
            @"Accept": @"application/json",
            @"Content-Type": @"application/json"
        };
        validatorConfiguration.timeoutIntervalForRequest = 60.0;
        validatorConfiguration.requestCachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;       
        
        ValidatorSession = [NSURLSession sessionWithConfiguration:validatorConfiguration];
    
    });
    return ValidatorSession;
}

#pragma mark Network

- (void)startRequestToValidateInstance:(id)instance withParams:(NSDictionary *)params
{
    _responseState.isWaitingForResponse = YES;
    
    NSError *error;
    
    NSMutableDictionary *requestParameters = [NSMutableDictionary dictionary];
    requestParameters[@"instance"] = instance ?: @""; // pre iOS 7, UITextField.text is nil by default
    if (params) requestParameters[@"extra"] = params;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:requestParameters options:kNilOptions error:&error];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_serviceURL];
    request.HTTPMethod = @"POST";
    request.HTTPBody = postData;
    
    void (^block)(NSData *, NSError *) = ^(NSData *data, NSError *error) {
        
        _responseState.isWaitingForResponse = NO;
        
        if (!error) {
            
            NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            BOOL isValid = [response isEqualToString:@"true"];
            _responseState.isValidResponse = isValid;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_requestCompletionHandler) _requestCompletionHandler(isValid, nil);
            });
            
            
            
        } else {
            
            _responseState.isValidResponse = NO;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.requestCompletionHandler) self.requestCompletionHandler(NO, error);
            });
            
        }
        
    };
    
    if (NSClassFromString(@"NSURLSession")) {
        NSURLSessionDataTask *validateTask = [[AJWValidatorRemoteRule validatorSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            block(data, error);
        }];
        
        [validateTask resume];
    }
    else {
        NSOperationQueue *queue = [NSOperationQueue new];
        [NSURLConnection sendAsynchronousRequest: request queue: queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            block(data, error);
        }];
    }
}

@end