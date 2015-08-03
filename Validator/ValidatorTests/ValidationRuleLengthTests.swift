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
    
    func testThatItCanValidateStringLength() {
        
        let rule = ValidationRuleLength(min: 5, max: 10, failureMessage: "Invalid!")
        
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
