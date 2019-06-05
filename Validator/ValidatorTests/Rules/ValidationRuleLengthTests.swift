import XCTest
@testable import Validator

class ValidationRuleLengthTests: XCTestCase {
    
    func testThatItCanValidateMinLength() {
        
        let rule = ValidationRuleLength(min: 5, error: testError)
        
        let tooShort = Validator.validate(input: "aaaa", rule: rule)
        XCTAssertFalse(tooShort.isValid)
        
        let valid = Validator.validate(input: "aaaaa", rule: rule)
        XCTAssertTrue(valid.isValid)
        
    }
    
    func testThatItCanValidateMaxLength() {
        
        let rule = ValidationRuleLength(max: 5, error: testError)
        
        let tooLong = Validator.validate(input: "aaaaaa", rule: rule)
        XCTAssertFalse(tooLong.isValid)
        
        let valid = Validator.validate(input: "aaaaa", rule: rule)
        XCTAssertTrue(valid.isValid)
        
    }
    
    func testThatItCanValidateRangeLength() {
        
        let rule = ValidationRuleLength(min: 5, max: 10, error: testError)
        
        let tooShort = Validator.validate(input: "aaaa", rule: rule)
        XCTAssertFalse(tooShort.isValid)
    
        let tooLong = Validator.validate(input: "aaaaaaaaaaa", rule: rule)
        XCTAssertFalse(tooLong.isValid)
        
        for input in ["aaaaa", "aaaaaaaaaa", "aaaaaaaa"] {
            let valid = Validator.validate(input: input, rule: rule)
            XCTAssertTrue(valid.isValid)
        }
        
    }

    func testThatItCanValidateEmojiCharacthersMinLength() {
        // NOTE: "🇯🇵".characters.count = 1

        let rule = ValidationRuleLength(min: 2, error: testError)

        let tooShort = Validator.validate(input: "🇯🇵", rule: rule)
        XCTAssertFalse(tooShort.isValid)

        let valid = Validator.validate(input: "🇯🇵🇯🇵", rule: rule)
        XCTAssertTrue(valid.isValid)
    }

    func testThatItCanValidateEmojiCharacthersMaxLength() {
        // NOTE: "🇯🇵".characters.count = 1

        let rule = ValidationRuleLength(max: 2, error: testError)

        let tooLong = Validator.validate(input: "🇯🇵🇯🇵🇯🇵", rule: rule)
        XCTAssertFalse(tooLong.isValid)

        let valid = Validator.validate(input: "🇯🇵🇯🇵", rule: rule)
        XCTAssertTrue(valid.isValid)
    }

    func testThatItCanValidateEmojiUTF8MinLength() {
        // NOTE: "🇯🇵".utf8.count = 8

        let rule = ValidationRuleLength(min: 16, lengthType: .utf8, error: testError)

        let tooShort = Validator.validate(input: "🇯🇵", rule: rule)
        XCTAssertFalse(tooShort.isValid)

        let valid = Validator.validate(input: "🇯🇵🇯🇵", rule: rule)
        XCTAssertTrue(valid.isValid)
    }

    func testThatItCanValidateEmojiUTF8MaxLength() {
        // NOTE: "🇯🇵".utf8.count = 8

        let rule = ValidationRuleLength(max: 16, lengthType: .utf8, error: testError)

        let tooLong = Validator.validate(input: "🇯🇵🇯🇵🇯🇵", rule: rule)
        XCTAssertFalse(tooLong.isValid)

        let valid = Validator.validate(input: "🇯🇵🇯🇵", rule: rule)
        XCTAssertTrue(valid.isValid)
    }

    func testThatItCanValidateEmojiUTF16MinLength() {
        // NOTE: "🇯🇵".utf16.count = 4

        let rule = ValidationRuleLength(min: 8, lengthType: .utf16, error: testError)

        let tooShort = Validator.validate(input: "🇯🇵", rule: rule)
        XCTAssertFalse(tooShort.isValid)

        let valid = Validator.validate(input: "🇯🇵🇯🇵", rule: rule)
        XCTAssertTrue(valid.isValid)
    }

    func testThatItCanValidateEmojiUTF16MaxLength() {
        // NOTE: "🇯🇵".utf16.count = 4

        let rule = ValidationRuleLength(max: 8, lengthType: .utf16, error: testError)

        let tooLong = Validator.validate(input: "🇯🇵🇯🇵🇯🇵", rule: rule)
        XCTAssertFalse(tooLong.isValid)

        let valid = Validator.validate(input: "🇯🇵🇯🇵", rule: rule)
        XCTAssertTrue(valid.isValid)
    }

    func testThatItCanValidateEmojiUnicodeScalarsMinLength() {
        // NOTE: "🇯🇵".unicodeScalars.count = 2

        let rule = ValidationRuleLength(min: 4, lengthType: .unicodeScalars, error: testError)

        let tooShort = Validator.validate(input: "🇯🇵", rule: rule)
        XCTAssertFalse(tooShort.isValid)

        let valid = Validator.validate(input: "🇯🇵🇯🇵", rule: rule)
        XCTAssertTrue(valid.isValid)
    }

    func testThatItCanValidateEmojiUnicodeScalarsMaxLength() {
        // NOTE: "🇯🇵".unicodeScalars.count = 2

        let rule = ValidationRuleLength(max: 4, lengthType: .unicodeScalars, error: testError)

        let tooLong = Validator.validate(input: "🇯🇵🇯🇵🇯🇵", rule: rule)
        XCTAssertFalse(tooLong.isValid)

        let valid = Validator.validate(input: "🇯🇵🇯🇵", rule: rule)
        XCTAssertTrue(valid.isValid)
    }
}
