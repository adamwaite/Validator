import Foundation

public struct ValidationRuleSet<InputType> {
    
    internal var rules = [AnyValidationRule<InputType>]()
    
    public init() {
    
    }
    
    public init<R: ValidationRule>(rules: [R]) where R.InputType == InputType {
        
        self.rules = rules.map(AnyValidationRule.init)
    }
    
    public mutating func add<R: ValidationRule>(rule: R) where R.InputType == InputType {
     
        let anyRule = AnyValidationRule(base: rule)
        rules.append(anyRule)
    }
}
