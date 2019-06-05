import Foundation

public protocol ValidationRule {
    
    associatedtype InputType
    
    func validate(input: InputType?) -> Bool
    
    var error: ValidationError { get }
}

internal struct AnyValidationRule<InputType>: ValidationRule {
    
    let error: ValidationError
    
    private let baseValidateInput: (InputType?) -> Bool
    
    init<Rule: ValidationRule>(base: Rule) where Rule.InputType == InputType {
        
        baseValidateInput = base.validate
        error = base.error
    }
    
    func validate(input: InputType?) -> Bool {
        
        return baseValidateInput(input)
    }

}
