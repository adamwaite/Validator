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
        
        let rule = ValidationRuleEquality<String>(failureMessage: "💣")
        
        let invalid = Validator.validate(input: ["password", "p@ssword"], rule: rule)
        XCTAssertFalse(invalid.isValid)

        let valid = Validator.validate(input: ["password", "password"], rule: rule)
        XCTAssertTrue(valid.isValid)
        
    }

    func testThatItCanValidateEqualityInNumbers() {
        
        let rule = ValidationRuleEquality<Double>(failureMessage: "💣")
        
        let invalid = Validator.validate(input: [1.0, 2.0], rule: rule)
        XCTAssertFalse(invalid.isValid)
        
        let valid = Validator.validate(input: [1.0, 1.0], rule: rule)
        XCTAssertTrue(valid.isValid)
        
    }
    
}
