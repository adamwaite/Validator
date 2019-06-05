import XCTest
@testable import Validator

class ValidationRuleEqualityTests: XCTestCase {

    func testThatItCanValidateEqualityInStrings() {
        
        let rule = ValidationRuleEquality<String>(target: "password", error: testError)
        
        let invalid = Validator.validate(input: "p@ssword", rule: rule)
        XCTAssertFalse(invalid.isValid)

        let valid = Validator.validate(input:"password", rule: rule)
        XCTAssertTrue(valid.isValid)
    }

    func testThatItCanValidateEqualityInNumbers() {
        
        let rule = ValidationRuleEquality<Double>(target: 1.0, error: testError)
        
        let invalid = Validator.validate(input: 2.0, rule: rule)
        XCTAssertFalse(invalid.isValid)
        
        let valid = Validator.validate(input: 1.0, rule: rule)
        XCTAssertTrue(valid.isValid)
    }
    
    func testThatItCanValidateDynamicProperties() {
        
        let textField = UITextField()
        textField.text = "password"
        let getter: (() -> String) = { return textField.text ?? "" }
        
        let rule = ValidationRuleEquality<String>(dynamicTarget: getter, error: testError)
        
        let invalid = Validator.validate(input: "p@ssword", rule: rule)
        XCTAssertFalse(invalid.isValid)
        
        let valid = Validator.validate(input: "password", rule: rule)
        XCTAssertTrue(valid.isValid)
        
    }
    
}
