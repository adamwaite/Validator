//
//  ValidationRuleComparableTests.swift
//  Validator
//
//  Created by Adam Waite on 16/07/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import XCTest
@testable import Validator

class ValidationRuleComparisonTests: XCTestCase {

    func testThatItCanValidateUsingAnIntegerRange() {

        let rule = ValidationRuleComparison<Int>(min: 5, max: 10, failureMessage: "Invalid!")

        let tooSmall = 4.validate(rule: rule);
        XCTAssertFalse(tooSmall.isValid)

        let tooLarge = 11.validate(rule: rule);
        XCTAssertFalse(tooLarge.isValid)

        for n in (5...10) {
            let valid = n.validate(rule: rule);
            XCTAssertTrue(valid.isValid)
        }

    }

    func testThatItCanValidateUsingADoubleRange() {

        let rule = ValidationRuleComparison<Double>(min: 5.0, max: 10.0, failureMessage: "Invalid!")

        let tooSmall = 4.0.validate(rule: rule);
        XCTAssertFalse(tooSmall.isValid)

        let tooLarge = 10.1.validate(rule: rule);
        XCTAssertFalse(tooLarge.isValid)

        for n in [5.4, 6.2, 7.7, 8.3, 9.1, 10.0] {
            let valid = n.validate(rule: rule);
            XCTAssertTrue(valid.isValid)
        }
        
    }
    
    func testThatItCanValidateCustomComparableTypes() {
        
        // PENDING
    
    }
    
}