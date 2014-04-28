/*
 
 ALPValidatorDemoTextFieldViewController.m
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

#import "ALPValidatorDemoTextFieldViewController.h"
#import "ALPValidator.h"

@interface ALPValidatorDemoTextFieldViewController () <UITextFieldDelegate, ALPValidatorDelegate>

@property (strong, nonatomic) ALPValidator *validator;
@property (copy, nonatomic) NSString *descriptionText;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextView *errorsTextView;

@end

@implementation ALPValidatorDemoTextFieldViewController

#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.descriptionLabel.text = self.descriptionText;
    self.textField.delegate = self;
    [self.textField attachValidator:self.validator];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.validator validate:self.textField.text];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.textField becomeFirstResponder];
}

#pragma mark Configure

- (void)configureWithDescription:(NSString *)desc validator:(ALPValidator *)validator
{
    self.descriptionText = desc;
    self.validator = validator;
}

#pragma mark Accessors

- (void)setValidator:(ALPValidator *)validator
{
    _validator = validator;
    _validator.delegate = self;
    
    __typeof__(self) __weak weakSelf = self;
    
    _validator.validatorStateChangedHandler = ^(ALPValidatorState newState) {
        
        switch (newState) {
            case ALPValidatorValidationStateValid: {
                [weakSelf handleValid];
                break;
            }
            case ALPValidatorValidationStateInvalid: {
                [weakSelf handleInvalid];
                break;
            }
            case ALPValidatorValidationStateWaitingForRemote: {
                [weakSelf handleWaiting];
                break;
            }
        }
    };
}

#pragma mark States

- (void)handleValid
{
    UIColor *validGreen = [UIColor colorWithRed:0.27 green:0.63 blue:0.27 alpha:1];
    self.textField.backgroundColor = [validGreen colorWithAlphaComponent:0.3];
    self.errorsTextView.text = NSLocalizedString(@"No errors 😃", nil);
    self.errorsTextView.textColor = validGreen;
}

- (void)handleInvalid
{
    UIColor *invalidRed = [UIColor colorWithRed:0.89 green:0.18 blue:0.16 alpha:1];
    self.textField.backgroundColor = [invalidRed colorWithAlphaComponent:0.3];
    self.errorsTextView.text = [self.validator.errorMessages componentsJoinedByString:@" 💣\n"];
    self.errorsTextView.textColor = invalidRed;
}

- (void)handleWaiting
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark ALPValidatorDelegate

- (void)validator:(ALPValidator *)validator remoteValidationAtURL:(NSURL *)url receivedResult:(BOOL)remoteConditionValid
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)validator:(ALPValidator *)validator remoteValidationAtURL:(NSURL *)url failedWithError:(NSError *)error
{
    
    NSLog(@"Remote service could not be contacted: %@. Have you started the sinatra server?", error);
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *errorMessage = [NSString stringWithFormat:@"The remote service could not be contacted: %@. Have you started the Sinatra server bundled with the demo?", error];
        UIAlertView *alertOnce = [[UIAlertView alloc] initWithTitle:@"Remote service error" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertOnce show];
    });
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
