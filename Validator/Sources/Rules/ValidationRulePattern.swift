import Foundation

public struct ValidationRulePattern: ValidationRule {
    
    public typealias InputType = String

    public let error: Error

    public let pattern: String
    
    public init(pattern: String, error: Error) {

        self.pattern = pattern
        self.error = error
    }
    
    public init(pattern: ValidationPattern, error: Error) {

        self.init(pattern: pattern.pattern, error: error)
    }

    public func validate(input: String?) -> Bool {

        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: input)
    }
}
