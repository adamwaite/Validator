import Foundation
@testable import Validator

extension String: ValidationError {
    
    public var message: String {
        
        return self
    }
}

extension Array {
    
    var random: Element {
        
        return randomElement()!
    }
}

extension Int {

    func times(_ closure: (Int) -> ()) {
        
        for i in 0..<self {
            closure(i)
        }
    }
}
