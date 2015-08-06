//
//  UITextField+ValidatorTests.swift
//  Validator
//
//  Created by Adam Waite on 06/08/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import XCTest
@testable import Validator

class UITextFieldValidatorTests: XCTestCase {
    
    func testThatItValidatesInputText() {
        
        let textField = UITextField()
        textField.text = "Hello"
        
        let rule = ValidationRuleCondition<String>(failureMessage: "💣") { $0.characters.contains("A") }
        
        let invalid = textField.validate(rule: rule)
        XCTAssertFalse(invalid.isValid)

        textField.text = "Hello Adam"
        
        let valid = textField.validate(rule: rule)
        XCTAssertTrue(valid.isValid)
        
    }

}
