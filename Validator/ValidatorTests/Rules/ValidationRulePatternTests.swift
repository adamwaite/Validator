import XCTest
@testable import Validator

class ValidationRulePatternTests: XCTestCase {

    func test_validate_email_valid() {
        
        let rule = ValidationRulePattern(pattern: EmailValidationPattern.standard, error: "💣")

        for validEmail in ["user@valid.com", "user_1@valid.co.uk", "user@valid.museum"] {
            let valid = Validator.validate(input: validEmail, rule: rule)
            XCTAssertTrue(valid.isValid)
        }
    }
    
    func test_validate_email_invalid() {

        let rule = ValidationRulePattern(pattern: EmailValidationPattern.standard, error: "💣")

        for invalidEmail in ["user@invalid,com", "userinvalid.com", "invalid", "user@invalid@example.com"] {
            let invalid = Validator.validate(input: invalidEmail, rule: rule)
            XCTAssertFalse(invalid.isValid, invalidEmail)
        }
    }
    
    func test_validate_digit_valid() {
        
        let rule = ValidationRulePattern(pattern: ContainsNumberValidationPattern(), error: "💣")

        for digitString in ["valid1", "9valid"] {
            let valid = Validator.validate(input: digitString, rule: rule)
            XCTAssertTrue(valid.isValid)
        }
    }
    
    func test_validate_digit_invalid() {
        
        let rule = ValidationRulePattern(pattern: ContainsNumberValidationPattern(), error: "💣")

        for noDigitString in ["invalid", "invali_d", "inv+alid"] {
            let invalid = Validator.validate(input: noDigitString, rule: rule)
            XCTAssertFalse(invalid.isValid)
        }
    }
}
