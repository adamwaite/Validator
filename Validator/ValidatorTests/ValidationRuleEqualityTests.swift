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
        
        let invalid = ["password", "p@ssword"].validate(rule: rule)
        XCTAssertFalse(invalid.isValid)

        let valid = ["password", "password"].validate(rule: rule)
        XCTAssertTrue(valid.isValid)
        
    }

    func testThatItCanValidateEqualityInNumbers() {
        
        let rule = ValidationRuleEquality<Double>(failureMessage: "💣")
        
        let invalid = [1.0, 2.0].validate(rule: rule)
        XCTAssertFalse(invalid.isValid)
        
        let valid = [1.0, 1.0].validate(rule: rule)
        XCTAssertTrue(valid.isValid)
        
    }
    
}
