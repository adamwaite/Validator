import XCTest
@testable import Validator

class ValidationRuleURLTests: XCTestCase {
    
    private let rule = ValidationRuleURL(error: "💣")
    
    func test_validate_valid() {
        
        for validURL in ["http://adamjwaite.co.uk", "http://google.com"] {
            let valid = Validator.validate(input: validURL, rule: rule)
            XCTAssertTrue(valid.isValid)
        }
    }
    
    func test_validate_invalid() {
        
        for invalidURL in ["http:▷adamjwaite.co.uk", "http://adamjwaite.co.uk?hello=😋"] {
            let invalid = Validator.validate(input: invalidURL, rule: rule)
            XCTAssertFalse(invalid.isValid)
        }
    }
}
