import Foundation

public enum ValidationResult {
    
    case valid
    
    case invalid([ValidationError])
    
    public var isValid: Bool {
        
        return self == .valid
    }
}

extension ValidationResult: Equatable {
    
    public static func == (lhs: ValidationResult, rhs: ValidationResult) -> Bool {
        
        switch (lhs, rhs) {
       
        case (.valid, .valid):
            return true
        
        case (.invalid(let a), .invalid(let b)):
            return a.map({ $0.message }).joined() == b.map({ $0.message }).joined()
        
        default:
            return false
        }
    }
}
