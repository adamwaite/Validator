import Foundation

public struct ContainsNumberValidationPattern: ValidationPattern {
    
    public init() {
        
    }
    
    public var pattern: String {
        return ".*\\d.*"
    }
}
