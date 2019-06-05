import Foundation

public struct ValidationRuleRequired<T>: ValidationRule {

    public typealias InputType = T
    
    public let error: Error
    
    public init(error: Error) {
    
        self.error = error
    }
    
    public func validate(input: T?) -> Bool {

        return input != nil
    }    
}
