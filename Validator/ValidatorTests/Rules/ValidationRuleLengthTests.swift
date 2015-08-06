//
//  ValidatorTests.swift
//  ValidatorTests
//
//  Created by Adam Waite on 09/07/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import XCTest
@testable import Validator

class ValidationRuleLengthTests: XCTestCase {
    
    func testThatItCanValidateMinLength() {
        
        let rule = ValidationRuleLength(min: 5, failureMessage: "💣")
        
        let tooShort = Validator.validate(input: "aaaa", rule: rule)
        XCTAssertFalse(tooShort.isValid)
        
        let valid = Validator.validate(input: "aaaaa", rule: rule)
        XCTAssertTrue(valid.isValid)
        
    }
    
    func testThatItCanValidateMaxLength() {
        
        let rule = ValidationRuleLength(max: 5, failureMessage: "💣")
        
        let tooLong = Validator.validate(input: "aaaaaa", rule: rule)
        XCTAssertFalse(tooLong.isValid)
        
        let valid = Validator.validate(input: "aaaaa", rule: rule)
        XCTAssertTrue(valid.isValid)
        
    }
    
    func testThatItCanValidateRangeLength() {
        
        let rule = ValidationRuleLength(min: 5, max: 10, failureMessage: "💣")
        
        let tooShort = Validator.validate(input: "aaaa", rule: rule)
        XCTAssertFalse(tooShort.isValid)
    
        let tooLong = Validator.validate(input: "aaaaaaaaaaa", rule: rule)
        XCTAssertFalse(tooLong.isValid)
        
        for input in ["aaaaa", "aaaaaaaaaa", "aaaaaaaa"] {
            let valid = Validator.validate(input: input, rule: rule)
            XCTAssertTrue(valid.isValid)
        }
        
    }
    
}
