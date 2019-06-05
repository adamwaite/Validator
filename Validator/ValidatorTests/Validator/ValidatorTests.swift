import XCTest
@testable import Validator

class ValidatorTests: XCTestCase {
    
    func testThatItCanEvaluateRules() {
        
        let err = testError
        
        let rule = ValidationRuleCondition<String>(error: err) { ($0?.count)! > 0 }
        
        let invalid = Validator.validate(input: "", rule: rule)
        XCTAssertEqual(invalid, ValidationResult.invalid([err]))
        
        let valid = Validator.validate(input: "😀", rule: rule)
        XCTAssertEqual(valid, ValidationResult.valid)
    }
    
    func testThatItCanEvaluateMultipleRules() {

        let err1 = testError
        let err2 = "💣💣"
        
        var ruleSet = ValidationRuleSet<String>()
        ruleSet.add(rule: ValidationRuleLength(min: 1, error: err1))
        ruleSet.add(rule: ValidationRuleCondition<String>(error: err2) { $0 == "😀" })
        
        let definitelyInvalid = Validator.validate(input: "", rules: ruleSet)
        XCTAssertEqual(definitelyInvalid, ValidationResult.invalid([err1, err2]))
        
        let partiallyValid = "😁".validate(rules: ruleSet)
        XCTAssertEqual(partiallyValid, ValidationResult.invalid([err2]))

        let valid = "😀".validate(rules: ruleSet)
        XCTAssertEqual(valid, ValidationResult.valid)
    }
}
