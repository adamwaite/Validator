import Foundation
import Validator

struct ExampleValidationError: ValidationError {

    let message: String
    
    public init(_ message: String) {
        
        self.message = message
    }
}
