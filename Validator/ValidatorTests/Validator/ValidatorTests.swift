import XCTest
@testable import Validator

class ValidatorTests: XCTestCase {
    
    func test_validate_singleRule_valid() {
        
        let rule = ValidationRuleCondition<String>(error: "💣") { _ in return true }
        let valid = Validator.validate(input: "😀", rule: rule)
        XCTAssertEqual(valid, .valid)
    }
    
    func test_validate_singleRule_invalid() {
        
        let rule = ValidationRuleCondition<String>(error: "💣") { _ in return false }
        let valid = Validator.validate(input: "😀", rule: rule)
        XCTAssertEqual(valid, .invalid(["💣"]))
    }
    
    func test_validate_multipleRules_valid() {
        
        var ruleSet = ValidationRuleSet<String>()
        ruleSet.add(rule: ValidationRuleLength(min: 1, error: "💣"))
        ruleSet.add(rule: ValidationRuleCondition<String>(error: "🧨") { $0 == "😀" })
        
        let valid = "😀".validate(rules: ruleSet)
        XCTAssertEqual(valid, .valid)
    }
    
    func test_validate_multipleRules_partiallyInvalid() {
        
        var ruleSet = ValidationRuleSet<String>()
        ruleSet.add(rule: ValidationRuleLength(min: 1, error: "💣"))
        ruleSet.add(rule: ValidationRuleCondition<String>(error: "🧨") { $0 == "😀" })
        
        let partiallyValid = "😁".validate(rules: ruleSet)
        XCTAssertEqual(partiallyValid, ValidationResult.invalid(["🧨"]))
    }
    
    func test_validate_multipleRules_definitelyInvalid() {
        
        var ruleSet = ValidationRuleSet<String>()
        ruleSet.add(rule: ValidationRuleLength(min: 1, error: "💣"))
        ruleSet.add(rule: ValidationRuleCondition<String>(error: "🧨") { $0 == "😀" })
        
        let definitelyInvalid = Validator.validate(input: "", rules: ruleSet)
        XCTAssertEqual(definitelyInvalid, ValidationResult.invalid(["💣", "🧨"]))
    }
}
