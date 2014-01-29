ALPValidator
===

ALPValidator provides drop in user input validation for your iOS apps. It's inspired by [jQuery Validation](https://github.com/jzaefferer/jquery-validation).

Current validations:
- Presence validation
- Minimum length validation
- Maximum length validation
Regular expression validation
- Email validation
- Custom block based validation
- Remote validation (calls a remote web service)

## Installation

Install with [CocoaPods](http://cocoapods.org):

`pod 'ALPValidator'`

### Usage

#### Creating an ALPValidator

1. Import:
```objective-c
#import "ALPValidator.h"
```

2. Create a validator instance using the designated initialiser:
```objective-c
ALPValidator *validator = [ALPValidator validatorWithType:ALPValidatorTypeString];
```

**Note**: There are plans to add validators for other object types, just strings are supported at the moment.


#### Adding Validation Rules

Add validation rules with the add rule methods. When adding a rule you can supply an error message string as an argument, this will appear in the `errorMessages` array should the validation fail. Some of the add rule methods take additional parameters, these should be self explanatory. You can add as many validation rules to the validator as you like.

- Presence validation:
```objective-c
- (void)addValidationToEnsurePresenceWithInvalidMessage:(NSString *)message;
```

- Minimum length validation:
```objective-c
- (void)addValidationToEnsureMinimumLength:(NSUInteger)minLength invalidMessage:(NSString message;
```

- Maximum length validation:
```objective-c
- (void)addValidationToEnsureMaximumLength:(NSUInteger)maxLength invalidMessage:(NSString *)message;
```

- Regular expression validation:
```objective-c
- (void)addValidationToEnsureRegularExpressionIsMetWithPattern:(NSString *)pattern invalidMessage:(NSString *)message;
```

- Valid email address validation:
```objective-c
- (void)addValidationToEnsureValidEmailWithInvalidMessage:(NSString *)message;
```

- Remote validation:
```objective-c
- (void)addValidationToEnsureRemoteConditionIsSatisfiedAtURL:(NSURL *)url invalidMessage:(NSString *)message;
```

- Custom block validation (return YES or NO from the block):
```objective-c
- (void)addValidationToEnsureCustomConditionIsSatisfiedWithBlock:(ALPValidatorCustomRuleBlock)block invalidMessage:(NSString *)message;
```

#### Validating

Use the validate method to validate an instance:

```objective-c
ALPValidator *validator = [ALPValidator validatorWithType:ALPValidatorTypeString];
[validator addValidationToEnsureValidEmailWithInvalidMessage:NSLocalizedString(@"That's not an email!", nil)];
[validator validate:@"hey"];
```

This will change the `state` property of the validator to:
`ALPValidatorValidationStateValid`

and the `isValid` method will return `YES`.

You could perhaps call `validate:` every time the text in a `UITextField` is changed and update the UI to reflect state for example.

#### Validation State Changed Handler

Use the `validatorStateChangedHandler` to be notified for a change in validation state. 

```objective-c
ALPValidator *someValidator = [ALPValidator validatorWithType:ALPValidatorTypeString];
someValidator.validatorStateChangedHandler = ^(ALPValidatorState newState) {
    switch (newState) {
        
        case ALPValidatorValidationStateValid:
            // do happy things
            break;
            
        case ALPValidatorValidationStateInvalid:
            // do unhappy things
            break;
            
        case ALPValidatorValidationStateWaitingForRemote:
            // do loading indicator things
            break;
            
    }
};
```

#### Validation Error Messages

When a validator fails, any error messages passed when adding rules are added to the public `errorMessages` array. You could perhaps use this array to notify the user why their inputs aren't up to scratch.

```objective-c
ALPValidator *mixedValidator = [ALPValidator validatorWithType:ALPValidatorTypeString];
[mixedValidator addValidationToEnsureMinimumLength:15 invalidMessage:NSLocalizedString(@"This is too long!", nil)];
[mixedValidator addValidationToEnsureCustomConditionIsSatisfiedWithBlock:^BOOL(NSString *instance) {
    return ([instance rangeOfString:@"A"].location == NSNotFound);
} invalidMessage:NSLocalizedString(@"No capital As are allowed", nil)];
[mixedValidator addValidationToEnsureValidEmailWithInvalidMessage:NSLocalizedString(@"That's not an email address!", nil)];
[mixedValidator validate:@"invA@lid,com"];
NSLog(@"%@", mixedValidator);
```

will log something similar to the following to the console:

```
ALPStringValidator 0x10911ddc0: {
    "_state" = 0;
    errorMessages =     (
        "This is too long!",
        "No capital As are allowed",
        "That's not an email address!"
    );
    "state as string" = Invalid;
}
```

#### More on Remote Validation

As with the [jQuery Validation](https://github.com/jzaefferer/jquery-validation) plug-in, ALPValidator supports remote validations. You can add a remote validation rule to a validator instance to ensure that a server-side condition is satisfied. This may for example be a condition that no two users can sign up to your service with the same username. 

Typically you might make a request to your registration service after a full sign up form has been filled. You would only then notify the user that their chosen username has been taken once the service has returned containing the error in a JSON response or suchlike. This user experience is improved if these requests are made on the fly as the user types and the UI is updated in closer to real time (maybe a red border on the field for username taken).

```objective-c
ALPValidator *remoteValidator = [ALPValidator validatorWithType:ALPValidatorTypeString];
[remoteValidator addValidationToEnsureRemoteConditionIsSatisfiedAtURL:[NSURL URLWithString:@"http:mycoolappbackend.com/api/usernameavailable"] invalidMessage:NSLocalizedString(@"That username has been taken", nil)];
```

Now when `validate:` is called the validator will change the `state` property to `ALPValidatorValidationStateWaitingForRemote` until the server responds. It will then change to `ALPValidatorValidationStateValid` or `ALPValidatorValidationStateInvalid` based on the response.

If the response is JSON "true" then the validation rule passes, if JSON "false' or anything else it will fail. The validation will also fail if the server fails to respond through an error. 

Optionally conform to `<ALPValidatorDelegate>` and set the `someValidator.delegate` property to receive notifications on server responding or failing through methods defined in `<ALPValidatorDelegate>`:

```objective-c
@protocol ALPValidatorDelegate <NSObject>

@optional
- (void)validator:(ALPValidator *)validator remoteValidationAtURL:(NSURL *)url receivedResult:(BOOL)remoteConditionValid;
- (void)validator:(ALPValidator *)validator remoteValidationAtURL:(NSURL *)url failedWithError:(NSError *)error;

@end
```

You may want to supply extra parameters with the request, you can do such with `validate:parameters:` method by supplying a dictionary containing any added parameters.

The remote validation request comes in the form of a HTTP POST request with an `application/json` content type. The HTTP body contains a JSON string containing the `"instance":` property (whatever you wish to validate) and an `"extras":` property if you supplied additional parameters.

Hopefully this makes sense, please get in touch if you're unsure.

#### Examples

There is an example project in this repository containing an example using each validation rule and a few other features. It doesn't have a user interface (yet, maybe one day) but it should show how you might set up and use ALPValidator in your iOS apps. To test the remote validation start the Sinatra server with the `ruby demo_server.rb` command.

## Roadmap

- Add a numeric validator (for age ranges, terms and conditions agreement etc)
- NSRange validation rule
- Improved error handling on remote validation
- Add ALPValidatorRemoteRule version using NSURLConnection for <iOS7 support

## Contributing

Contributing is encouraged! Before making a pull request please ensure all of the [Kiwi](https://github.com/allending/Kiwi) specs pass if your changing existing code, or you back new features up with new specs. Thanks.

## Contact

[@adamwaite](twitter.com/adamwaite)

##License

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
