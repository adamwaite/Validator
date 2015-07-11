//
//  ValidationRuleCustomTests.swift
//  Validator
//
//  Created by Adam Waite on 10/07/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import XCTest
@testable import Validator

class ValidationRuleConditionTests: XCTestCase {
    
    func testThatItCanValidateCustomConditions() {

        let ruleA = ValidationRuleCondition<String>(failureMessage: "💣") { $0.rangeOfString("A") == nil }
        
        let invalidA = "invAlid".validate(rule: ruleA)
        XCTAssertFalse(invalidA.isValid)
        
        let validA = "😀".validate(rule: ruleA)
        XCTAssertTrue(validA.isValid)
        
        let ruleB = ValidationRuleCondition<[Int]>(failureMessage: "💣") { $0.reduce(0, combine: +) > 50 }
        
        let invalidB = [40, 1, 5].validate(rule: ruleB)
        XCTAssertFalse(invalidB.isValid)
        
        let validB = [45, 1, 5].validate(rule: ruleB)
        XCTAssertTrue(validB.isValid)
        
    }
    
}