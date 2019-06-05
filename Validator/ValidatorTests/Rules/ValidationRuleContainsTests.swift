import XCTest
@testable import Validator

class ValidationRuleContainsTests: XCTestCase {
    
    func testThatItCanValidateContainsString() {
        
        let rule = ValidationRuleContains<String, [String]>(sequence: ["hello", "hi", "hey"], error: testError)
        
        for notInSequence in ["adam", "😋", "HEY"] {
            let invalid = Validator.validate(input: notInSequence, rule: rule)
            XCTAssertFalse(invalid.isValid)
        }
        
        for inSequence in ["hello", "hi", "hey"] {
            let valid = Validator.validate(input: inSequence, rule: rule)
            XCTAssertTrue(valid.isValid)
        }
    }
    
    func testThatItCanValidateContainsInt() {
        
        let rule = ValidationRuleContains<Int, [Int]>(sequence: [1, 2, 3], error: testError)
        
        for notInSequence in [4, 5, 6] {
            let invalid = Validator.validate(input: notInSequence, rule: rule)
            XCTAssertFalse(invalid.isValid)
        }
        
        for inSequence in [1, 2, 3] {
            let valid = Validator.validate(input: inSequence, rule: rule)
            XCTAssertTrue(valid.isValid)
        }
    }
}
