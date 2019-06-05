import Foundation

public struct ValidationRuleURL: ValidationRule {
    
    public typealias InputType = String
    
    public let error: Error

    public init(error: Error) {

        self.error = error
    }
    
    public func validate(input: String?) -> Bool {
        
        guard let input = input else {
            
            return false
        }
        
        return NSURL(string: input) != nil
    }
}
