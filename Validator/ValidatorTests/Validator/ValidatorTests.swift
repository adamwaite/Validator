//
//  ValidatorTests.swift
//  Validator
//
//  Created by Adam Waite on 01/08/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import XCTest
@testable import Validator

class ValidatorTests: XCTestCase {
    
    func testThatItCanEvaluateRules() {
        
        let rule = ValidationRuleCondition<String>(failureMessage: "💣") { $0.characters.count > 0 }
        
        let invalid = Validator.validate(input: "", rule: rule)
        XCTAssertEqual(invalid, .Invalid(["💣"]))
        
        let valid = Validator.validate(input: "😀", rule: rule)
        XCTAssertEqual(valid, .Valid)
        
    }
    
    func testThatItCanEvaluateMultipleRules() {

        var ruleSet = ValidationRuleSet<String>()
        ruleSet.addRule(ValidationRuleLength(min: 1, failureMessage: "💣"))
        ruleSet.addRule(ValidationRuleCondition<String>(failureMessage: "💣💣") { $0 == "😀" })
        
        let definitelyInvalid = Validator.validate(input: "", rules: ruleSet)
        XCTAssertEqual(definitelyInvalid, .Invalid(["💣", "💣💣"]))
        
        let partiallyValid = "😁".validate(rules: ruleSet)
        XCTAssertEqual(partiallyValid, .Invalid(["💣💣"]))

        let valid = "😀".validate(rules: ruleSet)
        XCTAssertEqual(valid, .Valid)
        
    }
    
}
