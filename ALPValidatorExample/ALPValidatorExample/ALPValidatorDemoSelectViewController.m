/*
 
 ALPValidatorDemoSelectViewController.m
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

#import "ALPValidatorDemoSelectViewController.h"
#import "ALPValidatorDemoTextFieldViewController.h"
#import "ALPValidator.h"

static NSString * const kTableDataKeyTitle = @"kTableDataKeyTitle";
static NSString * const kTableDataKeyDescription = @"kTableDataKeyDescription";
static NSString * const kTableDataKeyValidator = @"kTableDataKeyValidator";

@interface ALPValidatorDemoSelectViewController ()

@property (strong, nonatomic) NSArray *tableData;

@end

@implementation ALPValidatorDemoSelectViewController

#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createTableData];
    self.title = NSLocalizedString(@"ALPValidator Demo", nil);
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
}

- (void)createTableData
{
    self.tableData = @[
        @{
            kTableDataKeyTitle: NSLocalizedString(@"Required", nil),
            kTableDataKeyDescription: NSLocalizedString(@"Validates to ensure the text field contains a non-empty value.", nil),
            kTableDataKeyValidator: [self demoRequiredValidator]
        },
        @{
            kTableDataKeyTitle: NSLocalizedString(@"Minimum length", nil),
            kTableDataKeyDescription: NSLocalizedString(@"Validates to ensure the text field contains at least 6 characters.", nil),
            kTableDataKeyValidator: [self demoMinLengthValidator]
        },
        @{
            kTableDataKeyTitle: NSLocalizedString(@"Maximum length", nil),
            kTableDataKeyDescription: NSLocalizedString(@"Validates to ensure the text field contains at most 8 characters.", nil),
            kTableDataKeyValidator: [self demoMaxLengthValidator]
        },
        @{
            kTableDataKeyTitle: NSLocalizedString(@"Range", nil),
            kTableDataKeyDescription: NSLocalizedString(@"Validates to ensure the text field contains min 3 and max 8 characters.", nil),
            kTableDataKeyValidator: [self demoRangeValidator]
        },
        @{
            kTableDataKeyTitle: NSLocalizedString(@"Regular expression", nil),
            kTableDataKeyDescription: NSLocalizedString(@"Validates to ensure the text field contains 'hello'.", nil),
            kTableDataKeyValidator: [self demoRegexValidator]
        },
        @{
            kTableDataKeyTitle: NSLocalizedString(@"Email address", nil),
            kTableDataKeyDescription: NSLocalizedString(@"Validates to ensure the text field contains a valid email address.", nil),
            kTableDataKeyValidator: [self demoEmailValidator]
        },
        @{
            kTableDataKeyTitle: NSLocalizedString(@"Equality validation", nil),
            kTableDataKeyDescription: NSLocalizedString(@"Validates to ensure the input field contains 'password'", nil),
            kTableDataKeyValidator: [self demoEqualityValidator]
        },
        @{
            kTableDataKeyTitle: NSLocalizedString(@"Custom validation", nil),
            kTableDataKeyDescription: NSLocalizedString(@"Uses a block to ensure that capital letter A is not in the input.", nil),
            kTableDataKeyValidator: [self demoCustomValidator]
        },
        @{
            kTableDataKeyTitle: NSLocalizedString(@"Multiple validations", nil),
            kTableDataKeyDescription: NSLocalizedString(@"A validator with 3 different rules.", nil),
            kTableDataKeyValidator: [self demoMultipleValidator]
        },
        @{
            kTableDataKeyTitle: NSLocalizedString(@"Remote validation", nil),
            kTableDataKeyDescription: NSLocalizedString(@"Validates at http://localhost:4567 to ensure the input doesn't contain the word 'invalid' (start the included Sinatra server).", nil),
            kTableDataKeyValidator: [self demoRemoteValidator]
        },
        @{
            kTableDataKeyTitle: NSLocalizedString(@"String contains number", nil),
            kTableDataKeyDescription: NSLocalizedString(@"Validates to ensure the text field contains at least one digit.", nil),
            kTableDataKeyValidator: [self demoStringContainsNumberValidator]
        },
    ];
}

#pragma mark Example Validators

- (ALPValidator *)demoRequiredValidator
{
    ALPValidator *validator = [ALPValidator validatorWithType:ALPValidatorTypeString];
    [validator addValidationToEnsurePresenceWithInvalidMessage:NSLocalizedString(@"This is required!", nil)];
    return validator;
}

- (ALPValidator *)demoMinLengthValidator
{
    ALPValidator *validator = [ALPValidator validatorWithType:ALPValidatorTypeString];
    [validator addValidationToEnsureMinimumLength:6 invalidMessage:NSLocalizedString(@"Min length is 6 characters!", nil)];
    return validator;
}

- (ALPValidator *)demoMaxLengthValidator
{
    ALPValidator *validator = [ALPValidator validatorWithType:ALPValidatorTypeString];
    [validator addValidationToEnsureMaximumLength:8 invalidMessage:NSLocalizedString(@"Max length is 8 characters!", nil)];
    return validator;
}

- (ALPValidator *)demoRegexValidator
{
    ALPValidator *validator = [ALPValidator validatorWithType:ALPValidatorTypeString];
    [validator addValidationToEnsureRegularExpressionIsMetWithPattern:@"hello" invalidMessage:NSLocalizedString(@"You have to say hello!", nil)];
    return validator;
}

- (ALPValidator *)demoEmailValidator
{
    ALPValidator *validator = [ALPValidator validatorWithType:ALPValidatorTypeString];
    [validator addValidationToEnsureValidEmailWithInvalidMessage:@"Must be a valid email address!"];
    return validator;
}

- (ALPValidator *)demoCustomValidator
{
    ALPValidator *validator = [ALPValidator validatorWithType:ALPValidatorTypeString];
    [validator addValidationToEnsureCustomConditionIsSatisfiedWithBlock:^BOOL(NSString *instance) {
        return ([instance rangeOfString:@"A"].location == NSNotFound);
    } invalidMessage:NSLocalizedString(@"No capital As are allowed!", nil)];
    return validator;
}

- (ALPValidator *)demoMultipleValidator
{
    ALPValidator *validator = [ALPValidator validatorWithType:ALPValidatorTypeString];
    [validator addValidationToEnsurePresenceWithInvalidMessage:NSLocalizedString(@"This is required!", nil)];
    [validator addValidationToEnsureMinimumLength:6 invalidMessage:NSLocalizedString(@"Min length is 6 characters!", nil)];
    [validator addValidationToEnsureValidEmailWithInvalidMessage:@"Must be a valid email address!"];
    return validator;
}

- (ALPValidator *)demoRemoteValidator
{
    ALPValidator *validator = [ALPValidator validatorWithType:ALPValidatorTypeString];
    [validator addValidationToEnsureRemoteConditionIsSatisfiedAtURL:[NSURL URLWithString:@"http:127.0.0.1:4567/validate"] invalidMessage:NSLocalizedString(@"Remote condition has not been satisfied", nil)];
    return validator;
}

- (ALPValidator *)demoEqualityValidator
{
    ALPValidator *validator = [ALPValidator validatorWithType:ALPValidatorTypeString];
    [validator addValidationToEnsureInstanceIsTheSameAs:@"password" invalidMessage:NSLocalizedString(@"Should be equal to 'password'", nil)];
    return validator;
}

- (ALPValidator *)demoRangeValidator
{
    ALPValidator *validator = [ALPValidator validatorWithType:ALPValidatorTypeString];
    [validator addValidationToEnsureRangeWithMinimum:@3 maximum:@8 invalidMessage:NSLocalizedString(@"Should be between 3 and 8 characters", nil)];
    return validator;
}

- (ALPValidator *)demoStringContainsNumberValidator
{
    ALPValidator *validator = [ALPValidator validatorWithType:ALPValidatorTypeString];
    [validator addValidationToEnsureStringContainsNumberWithInvalidMessage:NSLocalizedString(@"Please add a digit to your entry", nil)];
    return validator;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ALPValidatorDemoTextFieldViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ALPValidatorDemoTextFieldViewController class])];
    NSDictionary *controllerData = _tableData[indexPath.row];
    [detailViewController configureWithDescription:controllerData[kTableDataKeyDescription] validator:controllerData[kTableDataKeyValidator]];
    detailViewController.title = _tableData[indexPath.row][kTableDataKeyTitle];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.textLabel.text = _tableData[indexPath.row][kTableDataKeyTitle];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableData.count;
}

@end