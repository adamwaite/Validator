import Foundation

public struct ValidationRuleEquality<T: Equatable>: ValidationRule {
    
    public let target: T?
    public let dynamicTarget: (() -> T)?
    public let error: ValidationError

    public init(target: T, error: ValidationError) {

        self.target = target
        self.error = error
        self.dynamicTarget = nil
    }
    
    public init(dynamicTarget: @escaping (() -> T), error: ValidationError) {

        self.dynamicTarget = dynamicTarget
        self.error = error
        self.target = nil
    }
  
    public func validate(input: T?) -> Bool {
  
        if let dynamicTarget = dynamicTarget {
           
            return input == dynamicTarget()
        }
        
        guard let target = target else {
            
            return false
        }
        
        return input == target
    }
}
