import Foundation

public struct ValidationRuleEquality<T: Equatable>: ValidationRule {

    public typealias InputType = T
    
    public let error: Error
    
    let target: T?
    
    let dynamicTarget: (() -> T)?
    
    public init(target: T, error: Error) {

        self.target = target
        self.error = error
        self.dynamicTarget = nil
    }
    
    public init(dynamicTarget: @escaping (() -> T), error: Error) {

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
