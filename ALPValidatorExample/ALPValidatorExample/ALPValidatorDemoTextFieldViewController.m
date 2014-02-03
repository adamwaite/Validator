//
//  ALPValidatorDemoTextFieldViewController.m
//  ALPValidator
//
//  Created by Adam Waite on 03/02/2014.
//  Copyright (c) 2014 Alpaca Labs. All rights reserved.
//

#import "ALPValidatorDemoTextFieldViewController.h"
#import "ALPValidator.h"

@interface ALPValidatorDemoTextFieldViewController () <UITextFieldDelegate, ALPValidatorDelegate>

@property (strong, nonatomic) ALPValidator *validator;
@property (copy, nonatomic) NSString *descriptionText;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *errors;

@end

@implementation ALPValidatorDemoTextFieldViewController

#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _descriptionLabel.text = _descriptionText;

    _textField.delegate = self;
    [_textField addTarget:self action:@selector(textFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_validator validate:_textField.text];
}

#pragma mark Change Handle

- (void)textFieldTextChanged:(UITextField *)sender
{
    [_validator validate:sender.text];
}

#pragma mark Configure

- (void)configureWithDescription:(NSString *)desc validator:(ALPValidator *)validator
{
    _descriptionText = desc;
    self.validator = validator;
}

#pragma mark Accessors

- (void)setValidator:(ALPValidator *)validator
{
    _validator = validator;
    
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
    _textField.backgroundColor = [validGreen colorWithAlphaComponent:0.3];
    _errors.text = NSLocalizedString(@"No errors :D", nil);
    _errors.textColor = validGreen;
}

- (void)handleInvalid
{
    UIColor *invalidRed = [UIColor colorWithRed:0.89 green:0.18 blue:0.16 alpha:1];
    _textField.backgroundColor = [invalidRed colorWithAlphaComponent:0.3];
    _errors.text = [_validator.errorMessages componentsJoinedByString:@"\n"];
    _errors.textColor = invalidRed;
}

- (void)handleWaiting
{
    _textField.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.3];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)handleResponse
{
    
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
    
}

- (void)validator:(ALPValidator *)validator remoteValidationAtURL:(NSURL *)url failedWithError:(NSError *)error
{
    
}

/*
 
 
 // Minimum length validation
 ALPValidator *minLenghtValidator = [ALPValidator validatorWithType:ALPValidatorTypeString];
 [minLenghtValidator addValidationToEnsureMinimumLength:6 invalidMessage:NSLocalizedString(@"This is not long enough!", nil)];
 [minLenghtValidator validate:@"small"];
 NSLog(@"%@", minLenghtValidator);
 [minLenghtValidator validate:@"biiiiig"];
 NSLog(@"%@", minLenghtValidator);
 
 // Maximum length validation
 ALPValidator *maxLenghtValidator = [ALPValidator validatorWithType:ALPValidatorTypeString];
 [maxLenghtValidator addValidationToEnsureMaximumLength:10 invalidMessage:NSLocalizedString(@"This is too long!", nil)];
 [maxLenghtValidator validate:@"short"];
 NSLog(@"%@", maxLenghtValidator);
 [maxLenghtValidator validate:@"loooooooong"];
 NSLog(@"%@", maxLenghtValidator);
 
 // Regular expression validation
 ALPValidator *regexValidator = [ALPValidator validatorWithType:ALPValidatorTypeString];
 [regexValidator addValidationToEnsureRegularExpressionIsMetWithPattern:@"hello" invalidMessage:NSLocalizedString(@"You have to say hello!", nil)];
 [regexValidator validate:@"hi"];
 NSLog(@"%@", regexValidator);
 [regexValidator validate:@"hello"];
 NSLog(@"%@", regexValidator);
 
 // Email validation
 ALPValidator *emailValidator = [ALPValidator validatorWithType:ALPValidatorTypeString];
 [emailValidator addValidationToEnsureValidEmailWithInvalidMessage:NSLocalizedString(@"That's not an email address!", nil)];
 [emailValidator validate:@"invalid@email,co,uk"];
 NSLog(@"%@", emailValidator);
 [regexValidator validate:@"valid@email.co.uk"];
 NSLog(@"%@", emailValidator);
 
 // Custom validation
 ALPValidator *customValidator = [ALPValidator validatorWithType:ALPValidatorTypeString];
 [customValidator addValidationToEnsureCustomConditionIsSatisfiedWithBlock:^BOOL(NSString *instance) {
 return ([instance rangeOfString:@"A"].location == NSNotFound);
 } invalidMessage:NSLocalizedString(@"No capital As are allowed", nil)];
 [customValidator validate:@"hAllo world!"];
 NSLog(@"%@", customValidator);
 [regexValidator validate:@"hello world!"];
 NSLog(@"%@", customValidator);
 
 // Multiple validations mixed together:
 ALPValidator *mixedValidator = [ALPValidator validatorWithType:ALPValidatorTypeString];
 [mixedValidator addValidationToEnsureMinimumLength:15 invalidMessage:NSLocalizedString(@"This is too short!", nil)];
 [mixedValidator addValidationToEnsureCustomConditionIsSatisfiedWithBlock:^BOOL(NSString *instance) {
 return ([instance rangeOfString:@"A"].location == NSNotFound);
 } invalidMessage:NSLocalizedString(@"No capital As are allowed!", nil)];
 [mixedValidator addValidationToEnsureValidEmailWithInvalidMessage:NSLocalizedString(@"That's not an email address!", nil)];
 [mixedValidator validate:@"invA@lid,com"];
 NSLog(@"%@", mixedValidator);
 [mixedValidator validate:@"valid@email.com"];
 NSLog(@"%@", mixedValidator);
 
 // Remote validation (Note - run the mock server using the Sinatra server included)
 // The server returns JSON "true" if the input does not contain the word "invalid" and JSON "false" otherwise.
 // The delegate logs the repsonse in this example
 ALPValidator *remoteValidator = [ALPValidator validatorWithType:ALPValidatorTypeString];
 [remoteValidator addValidationToEnsureRemoteConditionIsSatisfiedAtURL:[NSURL URLWithString:@"http:127.0.0.1:4567/validate"] invalidMessage:NSLocalizedString(@"Remote condition has not been satisfied", nil)];
 remoteValidator.delegate = self;
 [remoteValidator validate:@"valid"];
 [remoteValidator validate:@"invalid"];
 
 // Change handlers
 ALPValidator *someValidator = [ALPValidator validatorWithType:ALPValidatorTypeString];
 someValidator.validatorStateChangedHandler = ^(ALPValidatorState newState) {
 switch (newState) {
 case ALPValidatorValidationStateValid:
 // do valid happy things
 break;
 case ALPValidatorValidationStateInvalid:
 // do invalid unhappy things
 break;
 case ALPValidatorValidationStateWaitingForRemote:
 // do loading indicator things
 break;
 }
 };

 */

@end
