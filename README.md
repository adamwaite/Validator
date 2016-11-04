# Validator

[![CocoaPods Compatible](https://img.shields.io/badge/pod-2.1.0-blue.svg)](https://github.com/CocoaPods/CocoaPods) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Validator is a user input validation library written in Swift. It's comprehensive, designed for extension, and leaves error handling and the UI up to you (as it should be).

```swift
let emailRule = ValidationRulePattern(pattern: EmailValidationPattern.standard, error: someValidationError)
"invalid@email,com".validate(emailRule) // -> .invalid(someValidationError)
```

```swift
let eighteenYearsAgo = Date().addingTimeInterval(-568024668)
let drinkingAgeRule = ValidationRuleComparison<Date>(min: eighteenYearsAgo, error: someValidationError)
let dateOfBirth = Date().addingTimeInterval(-662695446) // 21 years old
dateOfBirth.validate(rule: rule) // -> .valid
```

```swift
let numericRule = ValidationRuleComparison<Int>(min: 50, max: Int.max, error: someValidationError)
17.validate(drinkingAgeRule) // -> .invalid(someValidationError)
```

```swift
let cardRule = ValidationRulePaymentCard(availableTypes: [.visa, .amex], error: someValidationError)
paymentCardTextField.validate(cardRule) // -> .valid or .invalid(someValidationError) dpeending on what's in paymentCardTextField
```

![demo-vid](resources/demo.mp4.gif)

## Features

- [x] Validation rules:
  - [x] Required
  - [x] Equality
  - [x] Comparison
  - [x] Length (min, max, range)
  - [x] Pattern (email, password constraints and more...)
  - [x] Contains
  - [x] URL
  - [x] Payment card (Luhn validated, accepted types)
  - [x] Condition (quickly write your own)
- [x] Swift standard library type extensions with one API (not just strings!)
- [x] UIKit element extensions
- [x] Open validation error types
- [x] An open protocol-oriented implementation
- [x] Comprehensive test coverage
- [x] Comprehensive code documentation

## Implementations

- The Swift 3 implementation is the actively maintained version on the [master branch](https://github.com/adamwaite/Validator), releases starting at version 2.0.
- A Swift 2.3 implemtation is in version [1.2.1](https://github.com/adamwaite/Validator/releases/tag/v1.2.1).
- Objective-C implementation is on the [objc branch](https://github.com/adamwaite/Validator/tree/objc).

## Installation

Install Validator with [CocoaPods](http://cocoapods.org):

`pod 'Validator'`

Install Validator with [Carthage](https://github.com/Carthage/Carthage):

`github "adamwaite/Validator"`

## Usage

`Validator` can validate any `Validatable` type using one or multiple `ValidationRule`s. A validation operation returns a `ValidationResult` which matches either `.valid` or `.invalid([Error])`.

```swift
let rule = ValidationRulePattern(pattern: EmailValidationPattern.standard, error: someValidationErrorType)

let result = "invalid@email,com".validate(rule: rule)
// Note: the above is equivalent to Validator.validate(input: "invalid@email,com", rule: rule)

switch result {
case .valid: print("😀")
case .invalid(let failures): print(failures.first?.message)
}
```

### Validation Rules

#### Required

Validates a type exists (not-nil).

```swift
let stringRequiredRule = ValidationRuleRequired<String?>(error: someValidationErrorType)

let floatRequiredRule = ValidationRuleRequired<Float?>(error: someValidationErrorType)
```

*Note - You can't use `validate` on an optional `Validatable` type (e.g. `myString?.validate(aRule...)` because the optional chaining mechanism will bypass the call. `"thing".validate(rule: aRule...)` is fine. To validate an optional for required in this way use: `Validator.validate(input: anOptional, rule: aRule)`.*

#### Equality

Validates an `Equatable` type is equal to another.

```swift
let staticEqualityRule = ValidationRuleEquality<String>(target: "hello", error: someValidationErrorType)

let dynamicEqualityRule = ValidationRuleEquality<String>(dynamicTarget: { return textField.text ?? "" }, error: someValidationErrorType)
```

#### Comparison

Validates a `Comparable` type against a maximum and minimum.

```swift
let comparisonRule = ValidationRuleComparison<Float>(min: 5, max: 7, error: someValidationErrorType)
```

#### Length

Validates a `String` length satisfies a minimum, maximum or range.

```swift
let minLengthRule = ValidationRuleLength(min: 5, error: someValidationErrorType)

let maxLengthRule = ValidationRuleLength(max: 5, error: someValidationErrorType)

let rangeLengthRule = ValidationRuleLength(min: 5, max: 10, error: someValidationErrorType)
```

#### Pattern

Validates a `String` against a pattern.

`ValidationRulePattern` can be initialized with a `String` pattern or a type conforming to `ValidationPattern`. Validator provides some common patterns in the Patterns directory.

```swift
let emailRule = ValidationRulePattern(pattern: EmailValidationPattern.standard, error: someValidationErrorType)

let digitRule = ValidationRulePattern(pattern: ContainsNumberValidationPattern(), error: someValidationErrorType)

let helloRule = ValidationRulePattern(pattern: ".*hello.*", error: someValidationErrorType)
```

#### Contains

Validates an `Equatable` type is within a predefined `SequenceType`'s elements (where the `Element` of the `SequenceType` matches the input type).

```swift
let stringContainsRule = ValidationRuleContains<String, [String]>(sequence: ["hello", "hi", "hey"], error: someValidationErrorType)

let rule = ValidationRuleContains<Int, [Int]>(sequence: [1, 2, 3], error: someValidationErrorType)
```

#### URL

Validates a `String` to see if it's a valid URL conforming to RFC 2396.

```swift
let urlRule = ValidationRuleURL(error: someValidationErrorType)
```

#### Payment Card

Validates a `String` to see if it's a valid payment card number by firstly running it through the [Luhn check algorithm](https://en.wikipedia.org/wiki/Luhn_algorithm), and secondly ensuring it follows the format of a number of payment card providers.

```swift
public enum PaymentCardType: Int {
    case amex, mastercard, visa, maestro, dinersClub, jcb, discover, unionPay
    ///...
```

To be validate against any card type (just the Luhn check):

```swift
let anyCardRule = ValidationRulePaymentCard(error: someValidationErrorType)
```

To be validate against a set of accepted card types (e.g Visa, Mastercard and American Express in this example):

```swift
let acceptedCardsRule = ValidationRulePaymentCard(acceptedTypes: [.visa, .mastercard, .amex], error: someValidationErrorType)
```

#### Condition

Validates a `Validatable` type with a custom condition.

```swift
let conditionRule = ValidationRuleCondition<[String]>(error: someValidationErrorType) { $0.contains("Hello") }
```

#### Create Your Own

Create your own validation rules by conforming to the `ValidationRule` protocol:

```swift
protocol ValidationRule {
    typealias InputType
    func validate(input: InputType) -> Bool
    var error: Error { get }
}
```

Example:

```swift
struct HappyRule {
    typealias InputType = String
    var error: ValidationError(message: "U mad?") }
    func validate(input: String) -> Bool {
        return input == "😀"
    }
}
```

> If your custom rule doesn't already exist in the library and you think it might be useful for other people, then it'd be great if you added it in with a [pull request](https://github.com/adamwaite/Validator/pulls).

### Multiple Validation Rules (`ValidationRuleSet`)

Validation rules can be combined into a `ValidationRuleSet` containing a collection of rules that validate a type.

```swift
var passwordRules = ValidationRuleSet<String>()

let minLengthRule = ValidationRuleLength(min: 5, error: someValidationErrorType)
passwordRules.add(rule: minLengthRule)

let digitRule = ValidationRulePattern(pattern: .ContainsDigit, error: someValidationErrorType)
passwordRules.add(rule: digitRule)
```

### Validatable

Any type that conforms to the `Validatable` protocol can be validated using the `validate:` method.

```swift
// Validate with a single rule:

let result = "some string".validate(rule: aRule)

// Validate with a collection of rules:

let result = 42.validate(rules: aRuleSet)
```

#### Extend Types As Validatable

Extend the `Validatable` protocol to make a new type validatable.

`extension Thing : Validatable { }`

Note: The implementation inside the protocol extension should mean that you don't need to implement anything yourself unless you need to validate multiple properties.

### ValidationResult

The `validate:` method returns a `ValidationResult` enum. `ValidationResult` can take one of two forms:

1. `.valid`: The input satisfies the validation rules.
2. `.invalid`: The input fails the validation rules. An `.invalid` result has an associated array of types conforming to `ValidationErrorType`.

You can combine two or more `ValidationResult`s together with `merge:`, `mergeMany:` and `ValidationResult.combine:`.

```swift
let result1 = ValidationResult.invalid([someError])
let result2 = ValidationResult.invalid([someError2])
let allResults = result1.merge(result2) // = ValidationResult.invalid([someError1, someError2])
let allResultsAgain = ValidationResult.combine([result1, result2]) // = ValidationResult.invalid([someError1, someError2])
```

### Errors

Initialize rules with any `Error` to be passed with the result on a failed vaildation.

Example:

```swift
struct User: Validatable {

    let email: String

    enum ValidationErrors: String, Error {
        case emailInvalid = "Email address is invalid"
        var message { return self.rawValue }
    }

    func validate() -> ValidationResult {
        let rule ValidationRulePattern(pattern: .emailAddress, error: ValidationErrors.emailInvalid)
        return email.validate(rule: rule)
    }
}

```

### Validating UIKit Elements

UIKit elements that conform to `ValidatableInterfaceElement` can have their input validated with the `validate:` method.

```swift
let textField = UITextField()
textField.text = "I'm going to be validated"

let slider = UISlider()
slider.value = 0.3

// Validate with a single rule:

let result = textField.validate(rule: aRule)

// Validate with a collection of rules:

let result = slider.validate(rules: aRuleSet)
```

#### Validate On Input Change

A `ValidatableInterfaceElement` can be configured to automatically validate when the input changes in 3 steps.

1. Attach a set of default rules:

    ```swift
    let textField = UITextField()
    var rules = ValidationRuleSet<String>()
    rules.add(rule: someRule)
    textField.validationRules = rules
    ```

2. Attach a closure to fire on input change:

    ```swift
    textField.validationHandler = { result in
	  switch result {
      case .valid:
		    print("valid!")
      case .invalid(let failureErrors):
		    let messages = failureErrors.map { $0.message }
        print("invalid!", messages)
      }
    }
    ```

3. Begin observation:

    ```swift
    textField.validateOnInputChange(enabled: true)
    ```

Note - Use `.validateOnInputChange(enabled: false)` to end observation.

#### Extend UI Elements As Validatable

Extend the `ValidatableInterfaceElement` protocol to make an interface element validatable.

Example:

```swift
extension UITextField: ValidatableInterfaceElement {

    typealias InputType = String

    var inputValue: String { return text ?? "" }

    func validateOnInputChange(enabled: Bool) {
        switch validationEnabled {
        case true: addTarget(self, action: #selector(validateInputChange), forControlEvents: .editingChanged)
        case false: removeTarget(self, action: #selector(validateInputChange), forControlEvents: .editingChanged)
        }
    }

    @objc private func validateInputChange(_ sender: UITextField) {
        sender.validate()
    }

}
```

The implementation inside the protocol extension should mean that you should only need to implement:

1.  The `typealias`: the type of input to be validated (e.g `String` for `UITextField`).
2.  The `inputValue`: the input value to be validated (e.g the `text` value for `UITextField`).
3.  The `validateOnInputChange:` method: to configure input-change observation.

## Examples

There's an example project in this repository.

## Contributing

Any contributions and suggestions are most welcome! Please ensure any new code is covered with unit tests, and that all existing tests pass. Please update the README with any new features. Thanks!

## Thanks

- Thanks to [@jedmund](https://github.com/jedmund) for converting this project to Swift 3.

## Contact

[@adamwaite](http://twitter.com/adamwaite)

## License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
