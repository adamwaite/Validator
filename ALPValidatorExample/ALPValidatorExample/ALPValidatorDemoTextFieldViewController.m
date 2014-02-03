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
@property (weak, nonatomic) IBOutlet UITextView *errorsTextView;

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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_textField becomeFirstResponder];
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
    _textField.backgroundColor = [validGreen colorWithAlphaComponent:0.3];
    _errorsTextView.text = NSLocalizedString(@"No errors :D", nil);
    _errorsTextView.textColor = validGreen;
}

- (void)handleInvalid
{
    UIColor *invalidRed = [UIColor colorWithRed:0.89 green:0.18 blue:0.16 alpha:1];
    _textField.backgroundColor = [invalidRed colorWithAlphaComponent:0.3];
    _errorsTextView.text = [_validator.errorMessages componentsJoinedByString:@"\n"];
    _errorsTextView.textColor = invalidRed;
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
    
    NSLog(@"Remote service could not be contacted: %@. Hace you started the sinatra server?", error);
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *errorMessage = [NSString stringWithFormat:@"The remote service could not be contacted: %@. Have you started the Sinatra server bundled with the demo?", error];
        UIAlertView *alertOnce = [[UIAlertView alloc] initWithTitle:@"Remote service error" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertOnce show];
    });
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
