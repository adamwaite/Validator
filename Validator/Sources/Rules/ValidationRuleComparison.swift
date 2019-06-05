import Foundation

public struct ValidationRuleComparison<T: Comparable>: ValidationRule {
    
    public let min: T
    public let max: T
    public let error: ValidationError

    public init(min: T, max: T, error: ValidationError) {

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
