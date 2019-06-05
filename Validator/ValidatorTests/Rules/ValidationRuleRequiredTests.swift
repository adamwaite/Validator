import XCTest
@testable import Validator

class ValidationRuleRequiredTests: XCTestCase {
    
    func testThatItCanValidateOptionalValues() {

        let rule = ValidationRuleRequired<String?>(error: testError)

        let invalid = Validator.validate(input: nil, rule: rule)
        XCTAssertFalse(invalid.isValid)

        let valid = Validator.validate(input: "hello", rule: rule)
        XCTAssertTrue(valid.isValid)
    }
}
