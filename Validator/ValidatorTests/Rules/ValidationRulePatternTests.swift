import XCTest
@testable import Validator

class ValidationRulePatternTests: XCTestCase {

    func testThatItCanValidateEmailAddresses() {
        
        let rule = ValidationRulePattern(pattern: EmailValidationPattern.standard, error: testError)

        for invalidEmail in ["user@invalid,com", "userinvalid.com", "invalid", "user@invalid@example.com"] {
            let invalid = Validator.validate(input: invalidEmail, rule: rule)
            XCTAssertFalse(invalid.isValid, invalidEmail)
        }
        
        for validEmail in ["user@valid.com", "user_1@valid.co.uk", "user@valid.museum"] {
            let valid = Validator.validate(input: validEmail, rule: rule)
            XCTAssertTrue(valid.isValid)
        }
        
    }
    
    func testThatItCanValidateDigitPresence() {
        
        let rule = ValidationRulePattern(pattern: ContainsNumberValidationPattern(), error: testError)
        
        for noDigitString in ["invalid", "invali_d", "inv+alid"] {
            let invalid = Validator.validate(input: noDigitString, rule: rule)
            XCTAssertFalse(invalid.isValid)
        }
        
        for digitString in ["valid1", "9valid"] {
            let valid = Validator.validate(input: digitString, rule: rule)
            XCTAssertTrue(valid.isValid)
        }
        
    }
}
