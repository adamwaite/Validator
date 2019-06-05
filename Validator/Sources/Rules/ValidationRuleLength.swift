import Foundation

public struct ValidationRuleLength: ValidationRule {

    public enum LengthType {

        case characters
        case utf8
        case utf16
        case unicodeScalars
    }
    
    public typealias InputType = String

    public var error: Error
    
    public let min: Int

    public let max: Int

    public let lengthType: LengthType

    public init(min: Int = 0, max: Int = Int.max, lengthType: LengthType = .characters, error: Error) {
        
        self.min = min
        self.max = max
        self.lengthType = lengthType
        self.error = error
    }
    
    public func validate(input: String?) -> Bool {

        guard let input = input else {
            
            return false
        }

        let length: Int
        
        switch lengthType {
        
        case .characters:
            length = input.count
        
        case .utf8:
            length = input.utf8.count
        
        case .utf16:
            length = input.utf16.count
        
        case .unicodeScalars:
            length = input.unicodeScalars.count
        
        }

        return length >= min && length <= max
    }

}
