import Foundation

public struct ValidationRuleURL: ValidationRule {
        
    public let error: ValidationError

    public init(error: ValidationError) {

        self.error = error
    }
    
    public func validate(input: String?) -> Bool {
        
        guard let input = input else {
            
            return false
        }
        
        return NSURL(string: input) != nil
    }
}
