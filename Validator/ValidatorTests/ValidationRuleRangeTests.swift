//
//  ValidatorTests.swift
//  ValidatorTests
//
//  Created by Adam Waite on 09/07/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import XCTest
@testable import Validator

class ValidationRuleRangeTests: XCTestCase {
    
    func testThatItCanValidateStringLength() {

        let rule = ValidationRuleRange<String>(min: 5, max: 10, failureMessage: "Invalid!")
    
        let tooShort = "aaaa".validate(rule: rule)
        XCTAssertFalse(tooShort.isValid)

        let tooLong = "aaaaaaaaaaa".validate(rule: rule)
        XCTAssertFalse(tooLong.isValid)
        
        for s in ["aaaaa", "aaaaaaaaaa", "aaaaaaaa"] {
            let valid = s.validate(rule: rule)
            XCTAssertTrue(valid.isValid)
        }
        
    }
    
    func testThatItCanValidateNumericRange() {
        
        let rule = ValidationRuleRange<ValidatableNumeric>(min: 5, max: 10, failureMessage: "Invalid!")
        
        let tooSmall = 4.validate(rule: rule);
        XCTAssertFalse(tooSmall.isValid)

        let tooLarge = 10.1.validate(rule: rule);
        XCTAssertFalse(tooLarge.isValid)
        
        for n in (5...10) {
            let validInt = Int(n).validate(rule: rule);
            XCTAssertTrue(validInt.isValid)
            
            let validDouble = Double(n).validate(rule: rule);
            XCTAssertTrue(validDouble.isValid)
            
            let validFloat = Float(n).validate(rule: rule);
            XCTAssertTrue(validFloat.isValid)
        }
        
    }
    
}
