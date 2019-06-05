import Foundation

public struct Validator {
    
    public static func validate<R: ValidationRule>(input: R.InputType?, rule: R) -> ValidationResult {
        
        var ruleSet = ValidationRuleSet<R.InputType>()
        ruleSet.add(rule: rule)
        return Validator.validate(input: input, rules: ruleSet)
    }
    
    public static func validate<T>(input: T?, rules: ValidationRuleSet<T>) -> ValidationResult {

        let errors = rules.rules.filter { !$0.validate(input: input) }.map { $0.error }
        return errors.isEmpty ? .valid : .invalid(errors)
    }
}
