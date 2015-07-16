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
    
        let tooShort = "aaaa".validate(rule: rule)
        XCTAssertFalse(tooShort.isValid)

        let tooLong = "aaaaaaaaaaa".validate(rule: rule)
        XCTAssertFalse(tooLong.isValid)
        
        for s in ["aaaaa", "aaaaaaaaaa", "aaaaaaaa"] {
            let valid = s.validate(rule: rule)
            XCTAssertTrue(valid.isValid)
        }
        
    }
    
}
