import Foundation

public enum ValidationResult {
    
    case valid

    case invalid([Error])
    
    public var isValid: Bool {
        
        return self == .valid
    }

    public func merge(with result: ValidationResult) -> ValidationResult {

        switch self {

        case .valid: return result

        case .invalid(let errorMessages):

            switch result {

            case .valid:
                return self

            case .invalid(let errorMessagesAnother):
                return .invalid([errorMessages, errorMessagesAnother].flatMap { $0 })
            }
        }
    }
    
    public func merge(with results: [ValidationResult]) -> ValidationResult {
    
        return results.reduce(self) { return $0.merge(with: $1) }
    }
    
    public static func merge(results: [ValidationResult]) -> ValidationResult {

        return ValidationResult.valid.merge(with: results)
    }
}

extension ValidationResult: Equatable {}

public func ==(lhs: ValidationResult, rhs: ValidationResult) -> Bool {

    switch (lhs, rhs) {

    case (.valid, .valid):
        return true

    case (.invalid(_), .invalid(_)):
        return true

    default:
        return false
    }
}
