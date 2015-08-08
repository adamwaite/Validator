# Validator

Validator is a user input validation library written in Swift.

```
let rule = ValidationRulePattern(pattern: .EmailAddress, failureMessage: “Input must be a valid email address”)

let result = “invalid@email,com”.validate(rule: rule)

switch result {
case .Valid: print(“😀”)
case .Invalid(let failures): print(failures.first?)
}
```

![demo-vid](resources/demo.mp4.gif)

## Features

- [x] Validation rules
- [x] Swift type extensions
- [x] UIKit element extensions
- [x] An easily extended protocol-oriented implementation

## Installation

Install Validator with [CocoaPods](http://cocoapods.org)

`pod ‘Validator’`


> Embedded frameworks require a minimum deployment target of iOS 8.

## Validation Rules

### Equality

Validates an `Equatable` type is equal to another.

```
let staticEqualityRule = ValidationRuleEquality<String>(target: “hello”, failureMessage: “Input does not equal ‘hello’”)

let dynamicEqualityRule = ValidationRuleEquality<String>(dynamicTarget: { return textField.text ?? “” }, failureMessage: “Input does not equal the input in the previous field”)
```

### Comparison

Validates a `Comparable` type against a maximum and minimum.

```
let comparisonRule = ValidationRuleComparison<Float>(min: 5, max: 7, failureMessage: “Input is not between 5 and 7”)
```

### Length

Validates a `String` length satisfies a minimum, maximum or range.

```
let minLengthRule = ValidationRuleLength(min: 5, failureMessage: “Input must be at least 5 characters”)

let maxLengthRule = ValidationRuleLength(max: 5, failureMessage: “Input must be at most 5 characters”)

let rangeLengthRule = ValidationRuleLength(min: 5, max: 10, failureMessage: “Input must be between 5 and 10 characters”)
```

### Pattern

Validates a `String` against a pattern. Validator provides some common patterns in the `ValidationPattern` enum.

```
let emailRule = ValidationRulePattern(pattern: .EmailAddress, failureMessage: “Input must be a valid email address”)

let digitRule = ValidationRulePattern(pattern: .ContainsDigit, failureMessage: “Input must contain a digit”)

let helloRule = ValidationRulePattern(pattern: ”.*hello.*”, failureMessage: “Input must contain the word hello”)
```

### Condition

Validates a `Validatable` type with a custom condition.

```
let conditionRule = ValidationRuleCondition<[String]>(failureMessage: “Collection does not contain the string ‘Hello’”) { $0.contains(“Hello”) }
```

### Create Your Own

Create your own validation rules by conforming to the `ValidationRule` protocol:

```
protocol ValidationRule {
    typealias InputType
    func validateInput(input: InputType) -> Bool
    var failureMessage: String { get }
}
```

Example:

```
struct HappyRule {
	typealias InputType = String
	var failureMessage: String { return “U mad?” }
	func validateInput(input: String) -> Bool { 
		return input == “😀”
	}
}
```

> If your custom rule doesn’t already exist in the library and you think it might be useful for other people, then it’d be great if you added it in with a [pull request](https://github.com/adamwaite/AJWValidator/pulls).

## Multiple Validation Rules (`ValidationRuleSet`)

Validation rules can be combined into a `ValidationRuleSet` containing a collection of rules that validate a type.

```
var passwordRules = ValidationRuleSet<String>()

let minLengthRule = ValidationRuleLength(min: 5, failureMessage: “Input must be at least 5 characters”)
passwordRules.addRule(minLengthRule)

let digitRule = ValidationRulePattern(pattern: .ContainsDigit, failureMessage: “Password must contain a digit”)
passwordRules.addRule(digitRule)
```

## Validate Types

Any type that conforms to the `Validatable` protocol can be validated using the `validate:` method.

```
// Validate with a single rule:

let result = “some string”.validate(rule: aRule)

// Validate with a collection of rules:

let result = 42.validate(rules: aRuleSet)
```

The `validate:` method returns a `ValidationResult` enum. `ValidationResult` can take one of two forms:

1. `.Valid`: The input satisfies the validation rules. 
2. `.Invalid`: The input fails the validation rules. An `.Invalid` result has an associated array of strings containing the failure messages defined in the rules (in the `failureMessage`s).

### Extend Types As Validatable

Extend the `Validatable` protocol to make a new type validatable.

`extension Thing : Validatable { }`

The implementation inside the protocol extension should mean that you don’t need to implement anything yourself.

## Validate UIKit Elements

UIKit elements that conform to `ValidatableInterfaceElement` can have their input validated with the `validate:` method.

```
let textField = UITextField()
textField.text = “I’m going to be validated”

let slider = UISlider()
slider.value = 0.3

// Validate with a single rule:

let result = textField.validate(rule: aRule)

// Validate with a collection of rules:

let result = slider.validate(rules: aRuleSet)
```

### Validate On Input Change

A `ValidatableInterfaceElement` can be configured to automatically validate when the input changes in 3 steps.

1. Attach a set of default rules:

```
let textField = UITextField()
let rules = ValidationRuleSet<String>()
rules.addRule(someRule)
textField.validationRules = rules
```

2. Attach a closure to fire on input change:

```
textField.validationHandler = { result in 
	switch result {
  case .Valid: 
		textField.textColor = UIColor.blackColor()
  case .Invalid(let failureMessages): 
		print(failureMessages)
		textField.textColor = UIColor.redColor()
  }
}
```

3. Begin observation:

`textField.validateOnInputChange(true)`

Note - Use `.validateOnInputChange(false)` to end observation.

### Extend UI Elements As Validatable

Extend the `ValidatableInterfaceElement` protocol to make an interface element validatable.

Example:

```
extension UITextField: ValidatableInterfaceElement {
    
    typealias InputType = String
    
    var inputValue: String { return text ?? “” }
    
    func validateOnInputChange(validationEnabled: Bool) {
        switch validationEnabled {
        case true: addTarget(self, action: “validateInputChange:”, forControlEvents: .EditingChanged)
        case false: removeTarget(self, action: “validateInputChange:”, forControlEvents: .EditingChanged)
        }
    }
    
    @objc private func validateInputChange(sender: UITextField) {
        sender.validate()
    }
    
}
```

The implementation inside the protocol extension should mean that you should only need to implement:

1.  The `typealias`: the type of input to be validated (e.g `String` for `UITextField`).
2.  The `inputValue`: the input value to be validated (e.g the `text` value for `UITextField`).
3.  The `validateOnInputChange:` method: to configure input-change observation.

## Examples

There’s an example project in this repository.

## Contributing

Any contributions and suggestions are most welcome! Please ensure any new code is covered with unit tests, and that all existing tests pass. Please update the README with any new features. Thanks!

## Contact

[@adamwaite](http://twitter.com/adamwaite)

## License

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
