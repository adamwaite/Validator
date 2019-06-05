import Foundation

public struct ValidationRuleCondition<T>: ValidationRule {
    
    public typealias InputType = T

    public let error: Error
    
    public let condition: (T?) -> Bool
    
    public init(error: Error, condition: @escaping ((T?) -> Bool)) {

        self.condition = condition
        self.error = error
    }
    
    public func validate(input: T?) -> Bool {

        return condition(input)
    }
    
}
