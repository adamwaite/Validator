import XCTest
@testable import Validator

class ValidationRuleConditionTests: XCTestCase {
    
    func testThatItCanValidateCustomConditions() {

        let ruleA = ValidationRuleCondition<String>(error: testError) { $0?.range(of: "A") == nil }
        
        let invalidA = Validator.validate(input: "invAlid", rule: ruleA)
        XCTAssertFalse(invalidA.isValid)
        
        let validA = Validator.validate(input: "😀", rule: ruleA)
        XCTAssertTrue(validA.isValid)
        
        let ruleB = ValidationRuleCondition<[Int]>(error: testError) { $0!.reduce(0, +) > 50 }

        let invalidB = Validator.validate(input: [40, 1, 5], rule: ruleB)
        XCTAssertFalse(invalidB.isValid)
        
        let validB = Validator.validate(input: [45, 1, 5], rule: ruleB)
        XCTAssertTrue(validB.isValid)
        
    }    
}
