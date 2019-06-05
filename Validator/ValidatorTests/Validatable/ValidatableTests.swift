import XCTest
@testable import Validator

class ValidatableTests: XCTestCase {
    
    func testThatItCanValidate() {
        
        let rule = ValidationRuleCondition<String>(error: testError) { ($0?.count)! > 0 }
        
        let invalid = "".validate(rule: rule)
        XCTAssertFalse(invalid.isValid)
        
        let valid = "😀".validate(rule: rule)
        XCTAssertTrue(valid.isValid)
    }    
}
