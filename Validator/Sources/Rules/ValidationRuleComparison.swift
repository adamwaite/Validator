import Foundation

public struct ValidationRuleComparison<T: Comparable>: ValidationRule {
    
    public typealias InputType = T
    
    public let error: Error
    
    let min: T
    
    let max: T
    
    public init(min: T, max: T, error: Error) {

        self.min = min
        self.max = max
        self.error = error
    }
    
    public func validate(input: T?) -> Bool {

        guard let input = input else {
            
            return false
        }
        
        return input >= min && input <= max
    }
    
}
