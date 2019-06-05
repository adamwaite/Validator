import Foundation

public struct ValidationRuleCondition<T>: ValidationRule {
    
    public let error: ValidationError
    public let condition: (T?) -> Bool
    
    public init(error: ValidationError, condition: @escaping ((T?) -> Bool)) {

        self.condition = condition
        self.error = error
    }
    
    public func validate(input: T?) -> Bool {

        return condition(input)
    }
    
}
