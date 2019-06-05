import XCTest
@testable import Validator

class ValidationRuleRequiredTests: XCTestCase {
    
    private let rule = ValidationRuleRequired<String?>(error: "💣")
    
    func test_validate_valid() {
        
        let valid = Validator.validate(input: "hello", rule: rule)
        XCTAssertTrue(valid.isValid)
    }
    
    func test_validate_invalid() {
        
        let invalid = Validator.validate(input: nil, rule: rule)
        XCTAssertFalse(invalid.isValid)
    }
}
