import XCTest
@testable import Validator

class ValidationRuleURLTests: XCTestCase {
    
    func testThatItCanValidateURL() {
        
        let rule = ValidationRuleURL(error: testError)
        
        for invalidURL in ["http:▷adamjwaite.co.uk", "http://adamjwaite.co.uk?hello=😋"] {
            let invalid = Validator.validate(input: invalidURL, rule: rule)
            XCTAssertFalse(invalid.isValid)
        }
        
        for validURL in ["http://adamjwaite.co.uk", "http://google.com"] {
            let valid = Validator.validate(input: validURL, rule: rule)
            XCTAssertTrue(valid.isValid)
        }
        
    }
}
