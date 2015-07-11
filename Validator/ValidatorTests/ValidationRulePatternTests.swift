//
//  ValidationRulePatternTests.swift
//  Validator
//
//  Created by Adam Waite on 11/07/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import XCTest
@testable import Validator

class ValidationRulePatternTests: XCTestCase {

    func testThatItCanValidateEmailAddresses() {
        
        let rule = ValidationRulePattern(pattern: .EmailAddress, failureMessage: "💣")

        for invalidEmail in ["user@invalid,com", "userinvalid.com", "invalid", "user@invalid@example.com", "user@in+valid.com"] {
            let invalid = invalidEmail.validate(rule: rule)
            XCTAssertFalse(invalid.isValid)
        }
        
        for validEmail in ["user@valid.com", "user_1@valid.co.uk"] {
            let valid = validEmail.validate(rule: rule)
            XCTAssertTrue(valid.isValid)
        }
        
    }
    
    func testThatItCanValidateDigitPresence() {
        
        let rule = ValidationRulePattern(pattern: .ContainsNumber, failureMessage: "💣")
        
        for noDigitString in ["invalid", "invali_d", "inv+alid"] {
            let invalid = noDigitString.validate(rule: rule)
            XCTAssertFalse(invalid.isValid)
        }
        
        for digitString in ["valid1", "9valid"] {
            let valid = digitString.validate(rule: rule)
            XCTAssertTrue(valid.isValid)
        }
        
    }
    
}
