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

## Features

- [x] Validation rules
- [x] Swift type extensions
- [x] UIKit element extensions
- [x] An easily-extended protocol-oriented implementation

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

## Combining Validation Rules in Validation Rule Sets

Validation rules can be combined into a `ValidationRuleSet` containing a collection of rules that validate a type.

```
let passwordRules = ValidationRuleSet<> 

### Validate a Type

Any type that conforms to the `Validatable` protocol can be validated using the `validate` method.

```
let rule = 
“invalid@email,com”
```




