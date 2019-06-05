import XCTest
@testable import Validator

class ValidationRuleComparisonTests: XCTestCase {

    func test_validate_integerRange_valid() {
        
        let rule = ValidationRuleComparison<Int>(min: 5, max: 10, error: "💣")
        
        for n in (5...10) {
            let valid = Validator.validate(input: n, rule: rule)
            XCTAssertTrue(valid.isValid)
        }
    }
    
    func test_validate_integerRange_invalid() {
     
        let rule = ValidationRuleComparison<Int>(min: 5, max: 10, error: "💣")
        
        let tooSmall = Validator.validate(input: 4, rule: rule)
        XCTAssertFalse(tooSmall.isValid)
        
        let tooLarge = Validator.validate(input: 11, rule: rule)
        XCTAssertFalse(tooLarge.isValid)
    }
    
    func test_validate_doubleRange_valid() {
        
        let rule = ValidationRuleComparison<Double>(min: 5.0, max: 10.0, error: "💣")

        for n in [5.4, 6.2, 7.7, 8.3, 9.1, 10.0] {
            let valid = Validator.validate(input: n, rule: rule)
            XCTAssertTrue(valid.isValid)
        }
    }
    
    func test_validate_doubleRange_invalid() {
        
        let rule = ValidationRuleComparison<Double>(min: 5.0, max: 10.0, error: "💣")
        
        let tooSmall = Validator.validate(input: 4.0, rule: rule)
        XCTAssertFalse(tooSmall.isValid)
        
        let tooLarge = Validator.validate(input: 10.1, rule: rule)
        XCTAssertFalse(tooLarge.isValid)
    }
}
