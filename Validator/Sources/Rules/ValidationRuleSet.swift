import Foundation

public struct ValidationRuleSet<InputType> {
    
    internal var rules = [AnyValidationRule<InputType>]()
    
    public init() {
    
    }
    
    public init<Rule: ValidationRule>(rules: [Rule]) where Rule.InputType == InputType {
        
        self.rules = rules.map(AnyValidationRule.init)
    }
    
    public mutating func add<Rule: ValidationRule>(rule: Rule) where Rule.InputType == InputType {
     
        let anyRule = AnyValidationRule(base: rule)
        rules.append(anyRule)
    }
}
