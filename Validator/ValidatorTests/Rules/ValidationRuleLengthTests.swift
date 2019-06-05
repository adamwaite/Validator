import XCTest
@testable import Validator

class ValidationRuleLengthTests: XCTestCase {
    
    func test_validate_minLength_valid() {
        
        let rule = ValidationRuleLength(min: 5, error: "💣")
        
        let valid = Validator.validate(input: "aaaaa", rule: rule)
        XCTAssertTrue(valid.isValid)
    }
    
    func test_validate_minLength_invalid() {
        
        let rule = ValidationRuleLength(min: 5, error: "💣")

        let tooShort = Validator.validate(input: "aaaa", rule: rule)
        XCTAssertFalse(tooShort.isValid)
    }
    
    func test_validate_maxLength_valid() {
        
        let rule = ValidationRuleLength(max: 5, error: "💣")

        let valid = Validator.validate(input: "aaaaa", rule: rule)
        XCTAssertTrue(valid.isValid)
    }
    
    func test_validate_maxLength_invalid() {
        
        let rule = ValidationRuleLength(max: 5, error: "💣")

        let tooLong = Validator.validate(input: "aaaaaa", rule: rule)
        XCTAssertFalse(tooLong.isValid)
    }
    
    func test_validate_range_valid() {
        
        let rule = ValidationRuleLength(min: 5, max: 10, error: "💣")

        for input in ["aaaaa", "aaaaaaaaaa", "aaaaaaaa"] {
            let valid = Validator.validate(input: input, rule: rule)
            XCTAssertTrue(valid.isValid)
        }
    }
    
    func test_validate_range_invalid() {
        
        let rule = ValidationRuleLength(min: 5, max: 10, error: "💣")

        let tooShort = Validator.validate(input: "aaaa", rule: rule)
        XCTAssertFalse(tooShort.isValid)
        
        let tooLong = Validator.validate(input: "aaaaaaaaaaa", rule: rule)
        XCTAssertFalse(tooLong.isValid)
    }
    
    
    func test_validate_characters_minLength() {
        
        // NOTE: "🇯🇵".characters.count = 1

        let rule = ValidationRuleLength(min: 2, error: "💣")

        let tooShort = Validator.validate(input: "🇯🇵", rule: rule)
        XCTAssertFalse(tooShort.isValid)

        let valid = Validator.validate(input: "🇯🇵🇯🇵", rule: rule)
        XCTAssertTrue(valid.isValid)
    }

    func test_validate_characters_maxLength() {
        
        // NOTE: "🇯🇵".characters.count = 1

        let rule = ValidationRuleLength(max: 2, error: "💣")

        let tooLong = Validator.validate(input: "🇯🇵🇯🇵🇯🇵", rule: rule)
        XCTAssertFalse(tooLong.isValid)

        let valid = Validator.validate(input: "🇯🇵🇯🇵", rule: rule)
        XCTAssertTrue(valid.isValid)
    }

    func test_validate_utf8_minLength() {
        
        // NOTE: "🇯🇵".utf8.count = 8

        let rule = ValidationRuleLength(min: 16, lengthType: .utf8, error: "💣")

        let tooShort = Validator.validate(input: "🇯🇵", rule: rule)
        XCTAssertFalse(tooShort.isValid)

        let valid = Validator.validate(input: "🇯🇵🇯🇵", rule: rule)
        XCTAssertTrue(valid.isValid)
    }

    func test_validate_utf8_maxLength() {

        // NOTE: "🇯🇵".utf8.count = 8

        let rule = ValidationRuleLength(max: 16, lengthType: .utf8, error: "💣")

        let tooLong = Validator.validate(input: "🇯🇵🇯🇵🇯🇵", rule: rule)
        XCTAssertFalse(tooLong.isValid)

        let valid = Validator.validate(input: "🇯🇵🇯🇵", rule: rule)
        XCTAssertTrue(valid.isValid)
    }

    func test_validate_utf16_minLength() {
        
        // NOTE: "🇯🇵".utf16.count = 4

        let rule = ValidationRuleLength(min: 8, lengthType: .utf16, error: "💣")

        let tooShort = Validator.validate(input: "🇯🇵", rule: rule)
        XCTAssertFalse(tooShort.isValid)

        let valid = Validator.validate(input: "🇯🇵🇯🇵", rule: rule)
        XCTAssertTrue(valid.isValid)
    }

    func test_validate_utf16_maxLength() {

        // NOTE: "🇯🇵".utf16.count = 4

        let rule = ValidationRuleLength(max: 8, lengthType: .utf16, error: "💣")

        let tooLong = Validator.validate(input: "🇯🇵🇯🇵🇯🇵", rule: rule)
        XCTAssertFalse(tooLong.isValid)

        let valid = Validator.validate(input: "🇯🇵🇯🇵", rule: rule)
        XCTAssertTrue(valid.isValid)
    }

    func test_validate_unicodeScalars_minLength() {
        
        // NOTE: "🇯🇵".unicodeScalars.count = 2

        let rule = ValidationRuleLength(min: 4, lengthType: .unicodeScalars, error: "💣")

        let tooShort = Validator.validate(input: "🇯🇵", rule: rule)
        XCTAssertFalse(tooShort.isValid)

        let valid = Validator.validate(input: "🇯🇵🇯🇵", rule: rule)
        XCTAssertTrue(valid.isValid)
    }

    func test_validate_unicodeScalars_maxLength() {
        
        // NOTE: "🇯🇵".unicodeScalars.count = 2

        let rule = ValidationRuleLength(max: 4, lengthType: .unicodeScalars, error: "💣")

        let tooLong = Validator.validate(input: "🇯🇵🇯🇵🇯🇵", rule: rule)
        XCTAssertFalse(tooLong.isValid)

        let valid = Validator.validate(input: "🇯🇵🇯🇵", rule: rule)
        XCTAssertTrue(valid.isValid)
    }
}
