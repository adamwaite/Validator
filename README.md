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
`pod ALPValidator`

### Usage

#### Creating an ALPValidator

1. Import:

`#import "ALPValidator.h"`

2. Create an instance using the designated initialiser:

```objective-c
ALPValidator *validator = [ALPValidator validatorWithType:ALPValidatorTypeString];
```

**Note**: ALP

