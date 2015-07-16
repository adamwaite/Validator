//
//  ValidatableStringTests.swift
//  Validator
//
//  Created by Adam Waite on 16/07/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import XCTest
@testable import Validator

class ValidatableStringTests: XCTestCase {
    
    func testThatItCanValidateWithARule() {
        
        let rule = ValidationRuleCondition<String>(failureMessage: "💣") { $0.characters.count > 0 }
        
        let invalid = "".validate(rule: rule)
        XCTAssertFalse(invalid.isValid)
        
        let valid = "😀".validate(rule: rule)
        XCTAssertTrue(valid.isValid)
        
    }
    
//    func testThatItCanValidateWithMultipleDifferentRules() {
//        
//        let rule1 = ValidationRuleCondition<String>(failureMessage: "💣") { $0.rangeOfString("😀") == nil }
//        let rule2 = ValidationRuleLength<String>(min: 1, failureMessage: "💣")
//        
//        let definitelyInvalid = "".validate(rules: [rule1, rule2])
//        XCTAssertFalse(definitelyInvalid.isValid)
//        
//        let partiallyValid = "😁".validate(rules: [rule1, rule2])
//        XCTAssertFalse(partiallyValid.isValid)
//
//        let valid = "😀".validate(rules: [rule1, rule2])
//        XCTAssertTrue(valid.isValid)
//
//    }
    
}
