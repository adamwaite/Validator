//
//  ValidatableInterfaceElementTests.swift
//  Validator
//
//  Created by Adam Waite on 06/08/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import XCTest
@testable import Validator

class ValidatableInterfaceElementTests: XCTestCase {
    
    func testThatItCanValidateInputValues() {
        
        let textField = UITextField()
        textField.text = "Hello"
        
        let rule = ValidationRuleCondition<String>(failureMessage: "💣") { $0.characters.contains("A") }
        
        let invalid = textField.validate(rule: rule)
        XCTAssertFalse(invalid.isValid)
        
        textField.text = "Hello Adam"
        
        let valid = textField.validate(rule: rule)
        XCTAssertTrue(valid.isValid)
        
    }
    
    func testThatItCanValidateInputValuesWithMultipleRules() {
        
        let textField = UITextField()
        textField.text = "Hi"
        
        var rules = ValidationRuleSet<String>()
        rules.addRule(ValidationRuleLength(min: 5, failureMessage: "💣"))
        rules.addRule(ValidationRuleCondition<String>(failureMessage: "💣") { $0.characters.contains("A") })
        
        let definitelyInvalid = textField.validate(rules: rules)
        XCTAssertFalse(definitelyInvalid.isValid)
        
        textField.text = "Hi adam"
        
        let partiallyInvalid = textField.validate(rules: rules)
        XCTAssertFalse(partiallyInvalid.isValid)
        
        textField.text = "Hi Adam"
        
        let valid = textField.validate(rules: rules)
        XCTAssertTrue(valid.isValid)
        
    }
    
}