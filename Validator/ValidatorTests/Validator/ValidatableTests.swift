import XCTest
@testable import Validator

class ValidatableTests: XCTestCase {
    
    private let rule = ValidationRuleCondition<String>(error: "💣") { ($0?.count)! > 0 }
    
    func test_validate_valid() {
        
        let valid = "😀".validate(rule: rule)
        XCTAssertTrue(valid.isValid)
    }
    
    func test_validate_invalid() {
        
        let invalid = "".validate(rule: rule)
        XCTAssertFalse(invalid.isValid)
    }
}
