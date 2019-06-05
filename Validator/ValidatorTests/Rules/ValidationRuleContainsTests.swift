import XCTest
@testable import Validator

class ValidationRuleContainsTests: XCTestCase {
    
    func test_validate_string_valid() {
        
        let rule = ValidationRuleContains<String, [String]>(sequence: ["hello", "hi", "hey"], error: "💣")

        for inSequence in ["hello", "hi", "hey"] {
            let valid = Validator.validate(input: inSequence, rule: rule)
            XCTAssertTrue(valid.isValid)
        }
    }
    
    func test_validate_string_invalid() {
        
        let rule = ValidationRuleContains<String, [String]>(sequence: ["hello", "hi", "hey"], error: "💣")

        for notInSequence in ["adam", "😋", "HEY"] {
            let invalid = Validator.validate(input: notInSequence, rule: rule)
            XCTAssertFalse(invalid.isValid)
        }
    }
    
    func test_validate_int_valid() {
    
        let rule = ValidationRuleContains<Int, [Int]>(sequence: [1, 2, 3], error: "💣")

        for inSequence in [1, 2, 3] {
            let valid = Validator.validate(input: inSequence, rule: rule)
            XCTAssertTrue(valid.isValid)
        }
    }
    
    func test_validate_int_invalid() {
    
        let rule = ValidationRuleContains<Int, [Int]>(sequence: [1, 2, 3], error: "💣")

        for notInSequence in [4, 5, 6] {
            let invalid = Validator.validate(input: notInSequence, rule: rule)
            XCTAssertFalse(invalid.isValid)
        }
    }
}
