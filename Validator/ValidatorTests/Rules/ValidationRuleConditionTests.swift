import XCTest
@testable import Validator

class ValidationRuleConditionTests: XCTestCase {
    
    private let ruleA = ValidationRuleCondition<String>(error: "💣") { $0?.range(of: "A") == nil }
    private let ruleB = ValidationRuleCondition<[Int]>(error: "💣") { $0!.reduce(0, +) > 50 }
    
    func test_validate_valid() {
        
        let validA = Validator.validate(input: "😀", rule: ruleA)
        XCTAssertTrue(validA.isValid)

        let validB = Validator.validate(input: [45, 1, 5], rule: ruleB)
        XCTAssertTrue(validB.isValid)
    }
    
    func test_validate_invalid() {

        let invalidA = Validator.validate(input: "invAlid", rule: ruleA)
        XCTAssertFalse(invalidA.isValid)
        
        let invalidB = Validator.validate(input: [40, 1, 5], rule: ruleB)
        XCTAssertFalse(invalidB.isValid)
    }
}
