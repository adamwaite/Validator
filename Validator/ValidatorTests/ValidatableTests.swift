//
//  ValidatableTests.swift
//  Validator
//
//  Created by Adam Waite on 16/07/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import XCTest
@testable import Validator

class ValidatableTests: XCTestCase {
    
    func testThatItCanValidate() {
        
        let rule = ValidationRuleCondition<String>(failureMessage: "💣") { $0.characters.count > 0 }
        
        let invalid = "".validate(rule: rule)
        XCTAssertFalse(invalid.isValid)
        
        let valid = "😀".validate(rule: rule)
        XCTAssertTrue(valid.isValid)
        
    }
    
}
