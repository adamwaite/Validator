import Foundation

public enum CaseValidationPattern: String, ValidationPattern {
    
    case uppercase, lowercase
    
    public var pattern: String {
        
        switch self {
        
        case .uppercase:
            return "^.*?[A-Z].*?$"
        
        case .lowercase:
            return "^.*?[a-z].*?$"
        }
    }
}
