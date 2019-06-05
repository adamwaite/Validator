import XCTest
@testable import Validator

class ValidationRuleEqualityTests: XCTestCase {

    func test_validate_staticString_valid() {
        
        let rule = ValidationRuleEquality<String>(target: "password", error: "💣")

        let valid = Validator.validate(input:"password", rule: rule)
        XCTAssertTrue(valid.isValid)
    }
    
    func test_validate_staticString_invalid() {
        
        let rule = ValidationRuleEquality<String>(target: "password", error: "💣")

        let invalid = Validator.validate(input: "p@ssword", rule: rule)
        XCTAssertFalse(invalid.isValid)
    }
    
    func test_validate_staticNumber_valid() {
        
        let rule = ValidationRuleEquality<Double>(target: 1.0, error: "💣")

        let valid = Validator.validate(input: 1.0, rule: rule)
        XCTAssertTrue(valid.isValid)
    }
    
    func test_validate_staticNumber_invalid() {
        
        let rule = ValidationRuleEquality<Double>(target: 1.0, error: "💣")

        let invalid = Validator.validate(input: 2.0, rule: rule)
        XCTAssertFalse(invalid.isValid)
    }
    
    func test_validate_dynamic_valid() {
        
        let textField = UITextField()
        textField.text = "password"
        let getter: (() -> String) = { return textField.text ?? "" }

        let rule = ValidationRuleEquality<String>(dynamicTarget: getter, error: "💣")

        let valid = Validator.validate(input: "password", rule: rule)
        XCTAssertTrue(valid.isValid)
    }
    
    func test_validate_dynamic_invalid() {
        
        let textField = UITextField()
        textField.text = "password"
        let getter: (() -> String) = { return textField.text ?? "" }

        let rule = ValidationRuleEquality<String>(dynamicTarget: getter, error: "💣")

        let invalid = Validator.validate(input: "p@ssword", rule: rule)
        XCTAssertFalse(invalid.isValid)
    }
}
