import Foundation

public protocol Validatable {

    func validate<Rule: ValidationRule>(rule: Rule) -> ValidationResult where Rule.InputType == Self
    
    func validate(rules: ValidationRuleSet<Self>) -> ValidationResult
}

extension Validatable {
    
    public func validate<R: ValidationRule>(rule: R) -> ValidationResult where R.InputType == Self {

        return Validator.validate(input: self, rule: rule)
    }
    
    public func validate(rules: ValidationRuleSet<Self>) -> ValidationResult {

        return Validator.validate(input: self, rules: rules)
    }
}

extension String : Validatable {
}

extension Int : Validatable {
}

extension Double : Validatable {
}

extension Float : Validatable {
}

extension Array : Validatable {
}

extension Date : Validatable {
}
