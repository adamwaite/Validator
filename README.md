# AJWValidator

> 💀 This library has been rewritten in Swift 2.0 and is no longer maintained in Objective-C (See [master](https://github.com/adamwaite/Validator/master). Here rests the final version (0.0.8).

AJWValidator provides drop in user input validation for your iOS apps. It features a number of built in validation rules, some convenience methods to verify user input, a validation state change handler block, a public error messages collection, and a category on UIView to provide validate-as-input functionality to supported input view types. It's not opinionated, it's your app and it's up to you how you want handle validation errors on the UI.

Built in validations:

- Presence validation
- Minimum length validation
- Maximum length validation
- Range validation (string character length and numeric)
- Equality validation (for password confirmation and such)
- Regular expression match validation
- Email address validation
- Custom block validation
- Remote validation (remote web service validation)
- Ensure string contains at least one digit
- *More to come as encountered!*

![demo-vid](resources/demo.mp4.gif)

*Note: the UI shown in the demo is nothing to do with the library, it's just some of the functionality on display.*

## Installation

Install with [CocoaPods](http://cocoapods.org):

`pod 'AJWValidator'`

## Usage

### Creating an AJWValidator

1. Import:

    `#import "AJWValidator.h"`

2. Create a string validator instance using:

    `AJWValidator *validator = [AJWValidator validatorWithType:AJWValidatorTypeString];`

    or a numeric validator:

    `AJWValidator *validator = [AJWValidator validatorWithType:AJWValidatorTypeNumeric];`

    or a generic validator:

    `AJWValidator *validator = [AJWValidator validator];

### Adding Validation Rules

Validation rules are added with the `addRule` methods. When adding a rule you can supply an error message string as an argument, this will appear in the `errorMessages` array should the validation fail. Some of the `addRule` methods take additional parameters, they should be self explanatory. You can add as many validation rules to a validator as you like.

- Presence validation:
```
- (void)addValidationToEnsurePresenceWithInvalidMessage:(NSString *)message;
```

- Minimum length validation:
```
- (void)addValidationToEnsureMinimumLength:(NSUInteger)minLength invalidMessage:(NSString message;
```

- Maximum length validation:
```
- (void)addValidationToEnsureMaximumLength:(NSUInteger)maxLength invalidMessage:(NSString *)message;
```

- Range validation:
```
- (void)addValidationToEnsureRangeWithMinimum:(NSNumber *)min maximum:(NSNumber *)max invalidMessage:(NSString *)message;
```

- Equality validation:
```
- (void)addValidationToEnsureInstanceIsTheSameAs:(id)otherInstance invalidMessage:(NSString *)message;
```

- Regular expression validation:
```
- (void)addValidationToEnsureRegularExpressionIsMetWithPattern:(NSString *)pattern invalidMessage:(NSString *)message;
```

- Valid email address validation:
```
- (void)addValidationToEnsureValidEmailWithInvalidMessage:(NSString *)message;
```

- Custom block validation (return `YES` or `NO` from the block):
```
- (void)addValidationToEnsureCustomConditionIsSatisfiedWithBlock:(AJWValidatorCustomRuleBlock)block invalidMessage:(NSString *)message;
```

- Remote validation:
```
- (void)addValidationToEnsureRemoteConditionIsSatisfiedAtURL:(NSURL *)url invalidMessage:(NSString *)message;
```

- String contains digit validation:
```
- (void)addValidationToEnsureStringContainsNumberWithInvalidMessage:(NSString *)message;
```

### Validating

Use the `validate:` method to validate an instance:

```
AJWValidator *validator = [AJWValidator validatorWithType:AJWValidatorTypeString];
[validator addValidationToEnsureValidEmailWithInvalidMessage:NSLocalizedString(@"That's not an email!", nil)];
[validator validate:@"hey"];
```

This will change the `state` property of the validator to `AJWValidatorValidationStateInvalid` and the `isValid` method will return `NO`.

To validate as the user types into a control you might do something such as this:

```
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.someTextField addTarget:self action:@selector(textFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldTextChanged:(UITextField *)sender
{
    [self.someValidator validate:sender.text];
}

```

Or alternatively use the `AJW_attachValidator:` method defined in the `UIView+AJWValidor` category to automatically configure validate-on-change functionality.

```
[self.someTextField AJW_attachValidator:someStringValidator];
```

### Validation State Changed Handler

Use the `validatorStateChangedHandler` to be notified for a change in validation state.

```
self.someValidator = [AJWValidator validatorWithType:AJWValidatorTypeString];
self.someValidator.validatorStateChangedHandler = ^(AJWValidatorState newState) {
    switch (newState) {

        case AJWValidatorValidationStateValid:
            // do happy things
            break;

        case AJWValidatorValidationStateInvalid:
            // do unhappy things
            break;

        case AJWValidatorValidationStateWaitingForRemote:
            // do loading indicator things
            break;

    }
};
```

See the example included in this repo for an idea on how to use the state change handler to update the UI with validation state as the user types into a control.

### Validation Error Messages

When a validator fails, any error messages passed when adding rules are added to the public `errorMessages` array. You could perhaps use this array to notify the user why their inputs aren't up to scratch.

```
AJWValidator *mixedValidator = [AJWValidator validatorWithType:AJWValidatorTypeString];

[mixedValidator addValidationToEnsureMinimumLength:15 invalidMessage:NSLocalizedString(@"This is too short!", nil)];

[mixedValidator addValidationToEnsureCustomConditionIsSatisfiedWithBlock:^BOOL(NSString *instance) {
    return ([instance rangeOfString:@"A"].location == NSNotFound);
} invalidMessage:NSLocalizedString(@"No capital As are allowed!", nil)];

[mixedValidator addValidationToEnsureValidEmailWithInvalidMessage:NSLocalizedString(@"That's not an email address!", nil)];

[mixedValidator validate:@"invA@lid,com"];

NSLog(@"%@", mixedValidator);
```

The above will NSLog something similar to the following:

```
AJWStringValidator 0x10911ddc0: {
    "_state" = 0;
    errorMessages =     (
        "This is too short!",
        "No capital As are allowed!",
        "That's not an email address!"
    );
    "state as string" = Invalid;
}
```

### UIView+AJWValidator

The `UIView+AJWValidator` category extends `UIView` to provide validation on the fly as the user changes the value of the input.

Use the `AJW_attachValidator:` to automatically configure the validator to call `validate:` (which fires the state change block) as the input changed.

```
[self.textField AJW_attachValidator:self.validator];
```

Remove auto-validation with `AJW_removeValidators`.

See the example project which uses the UIView category to validate as you type.

#### Supported

- `UITextField`
- `UITextView`

### Remote Validation

As with the [jQuery Validation](https://github.com/jzaefferer/jquery-validation) plug-in, AJWValidator supports remote validations. You can add a remote validation rule to a validator instance to ensure that a server-side condition is satisfied. This may for example be a condition that no two users can sign up to your service with the same username.

Typically you might make a request to your registration service after a full sign up form has been populated and a button has been tapped. You would only then notify the user that their chosen username has been taken once the service has returned containing the error in a JSON response or suchlike. This experience is improved if these requests are made asynchronously as the user types and the UI is updated to tell the user in closer to real-time.

```
AJWValidator *remoteValidator = [AJWValidator validatorWithType:AJWValidatorTypeString];
[remoteValidator addValidationToEnsureRemoteConditionIsSatisfiedAtURL:[NSURL URLWithString:@"http://app-backend.com/api/usernameavailable"] invalidMessage:NSLocalizedString(@"That username has been taken", nil)];
```

Now when `validate:` is called the validator will change the `state` property to `AJWValidatorValidationStateWaitingForRemote` until the server responds. It will then change to `AJWValidatorValidationStateValid` or `AJWValidatorValidationStateInvalid` based on the response.

If the response is JSON `true` then the validation rule passes, if JSON `false` or anything else it will fail. The validation will also fail if the server fails to respond through an error.

Optionally conform to `<AJWValidatorDelegate>` and set the `delegate` property to receive notifications when a server responds successfully or a request fails. The delegate methods you should implement for this information are defined in `<AJWValidatorDelegate>`:

```
@protocol AJWValidatorDelegate <NSObject>

@optional
- (void)validator:(AJWValidator *)validator remoteValidationAtURL:(NSURL *)url receivedResult:(BOOL)remoteConditionValid;
- (void)validator:(AJWValidator *)validator remoteValidationAtURL:(NSURL *)url failedWithError:(NSError *)error;

@end
```

You may want to supply extra parameters with the request, you can do such with the `validate:parameters:` method by supplying an `NSDictionary` containing any additional parameters.

The remote validation request comes in the form of a HTTP POST request with an `application/json` content type. The HTTP body contains a JSON string containing the `"instance":` property (whatever you wish to validate) and an `"extras":` property (containing any additional parameters if an `NSDictionary` was passed). You should be able to grab these on your server side code and respond after some conditions have been evaluated.

## Examples

An Xcode project has been included in this repository containing an example for each validation rule and some other features. To test the remote validation start the [Sinatra](http://www.sinatrarb.com) server with the `ruby demo_server.rb` command.

## Roadmap

- File type validator (max size on images etc)
- Phone number validation
- Credit card validation
- Postal code validation
- Input exists in a collection validation (for select type inputs)

## Contributing

Contributions welcome. Before making a pull request please ensure all of the [Kiwi](https://github.com/allending/Kiwi) specs pass if you're changing existing code, or you back new features up with new specs. Please also update the README with any new features. Thanks.

## Contact

[@adamwaite](http://twitter.com/adamwaite)

## Thanks

AJWValidator is inspired by [jQuery Validation](https://github.com/jzaefferer/jquery-validation) and [ParsleyJS](http://parsleyjs.org), thanks.

##License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
