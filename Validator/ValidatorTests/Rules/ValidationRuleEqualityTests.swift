//
//  ValidationRuleEqualityTests.swift
//  Validator
//
//  Created by Adam Waite on 11/07/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import XCTest
@testable import Validator

class ValidationRuleEqualityTests: XCTestCase {

    func testThatItCanValidateEqualityInStrings() {
        
        let rule = ValidationRuleEquality<String>(target: "password", failureMessage: "💣")
        
        let invalid = Validator.validate(input: "p@ssword", rule: rule)
        XCTAssertFalse(invalid.isValid)

        let valid = Validator.validate(input:"password", rule: rule)
        XCTAssertTrue(valid.isValid)
        
    }

    func testThatItCanValidateEqualityInNumbers() {
        
        let rule = ValidationRuleEquality<Double>(target: 1.0, failureMessage: "💣")
        
        let invalid = Validator.validate(input: 2.0, rule: rule)
        XCTAssertFalse(invalid.isValid)
        
        let valid = Validator.validate(input: 1.0, rule: rule)
        XCTAssertTrue(valid.isValid)
        
    }
    
    func testThatItCanValidateDynamicProperties() {
        
        let textField = UITextField()
        textField.text = "password"
        let getter: (() -> String) = { return textField.text ?? "" }
        
        let rule = ValidationRuleEquality<String>(dynamicTarget: getter, failureMessage: "💣")
        
        let invalid = Validator.validate(input: "p@ssword", rule: rule)
        XCTAssertFalse(invalid.isValid)
        
        let valid = Validator.validate(input: "password", rule: rule)
        XCTAssertTrue(valid.isValid)
        
    }
    
}
