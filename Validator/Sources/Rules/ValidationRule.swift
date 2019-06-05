import Foundation

public protocol ValidationRule {
    
    associatedtype InputType
    
    func validate(input: InputType?) -> Bool
    
    var error: Error { get }
}

internal struct AnyValidationRule<InputType>: ValidationRule {
    
    private let baseValidateInput: (InputType?) -> Bool
    
    let error: Error
    
    init<R: ValidationRule>(base: R) where R.InputType == InputType {
        
        baseValidateInput = base.validate
        error = base.error
    }
    
    func validate(input: InputType?) -> Bool {
        
        return baseValidateInput(input)
    }

}
