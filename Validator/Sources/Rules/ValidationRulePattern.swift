import Foundation

public struct ValidationRulePattern: ValidationRule {
    
    public let pattern: String
    public let error: ValidationError
    
    public init(pattern: String, error: ValidationError) {

        self.pattern = pattern
        self.error = error
    }
    
    public init(pattern: ValidationPattern, error: ValidationError) {

        self.init(pattern: pattern.pattern, error: error)
    }

    public func validate(input: String?) -> Bool {

        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: input)
    }
}
