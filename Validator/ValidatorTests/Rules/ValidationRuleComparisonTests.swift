import XCTest
@testable import Validator

class ValidationRuleComparisonTests: XCTestCase {

    func testThatItCanValidateUsingAnIntegerRange() {

        let rule = ValidationRuleComparison<Int>(min: 5, max: 10, error: testError)

        let tooSmall = Validator.validate(input: 4, rule: rule)
        XCTAssertFalse(tooSmall.isValid)

        let tooLarge = Validator.validate(input: 11, rule: rule)
        XCTAssertFalse(tooLarge.isValid)

        for n in (5...10) {
            let valid = Validator.validate(input: n, rule: rule)
            XCTAssertTrue(valid.isValid)
        }
    }

    func testThatItCanValidateUsingADoubleRange() {

        let rule = ValidationRuleComparison<Double>(min: 5.0, max: 10.0, error: testError)

        let tooSmall = Validator.validate(input: 4.0, rule: rule)
        XCTAssertFalse(tooSmall.isValid)

        let tooLarge = Validator.validate(input: 10.1, rule: rule)
        XCTAssertFalse(tooLarge.isValid)

        for n in [5.4, 6.2, 7.7, 8.3, 9.1, 10.0] {
            let valid = Validator.validate(input: n, rule: rule)
            XCTAssertTrue(valid.isValid)
        }
        
    }
    
}
