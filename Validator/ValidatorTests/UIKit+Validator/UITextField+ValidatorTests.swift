/*

 UITextFieldValidatorTests.swift
 Validator

 Created by @adamwaite.

 Copyright (c) 2015 Adam Waite. All rights reserved.

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.

*/

import XCTest
@testable import Validator

private final class TextField: UITextField {
    
}

class UITextFieldValidatorTests: XCTestCase {
    
    func testThatItProvidesAnInputValue() {
        let textField = UITextField()
        textField.text = "Hello"
        XCTAssertTrue(textField.inputValue == "Hello")
    }
    
    func testThatItCanValidateInputText() {
        let textField = UITextField()
        textField.text = "Hello"
        let rule = ValidationRuleCondition<String>(failureError: testError) { ($0?.characters.contains("A"))! }
        let invalid = textField.validate(rule: rule)
        XCTAssertFalse(invalid.isValid)
        textField.text = "Hello Adam"
        let valid = textField.validate(rule: rule)
        XCTAssertTrue(valid.isValid)
    }
    
    func testThatItCanValidateOnInputChange() {
        let textField = UITextField()
        
        var rules = ValidationRuleSet<String>()
        let rule = ValidationRuleCondition<String>(failureError: testError) { ($0?.characters.contains("A"))! }
        rules.add(rule: rule)
        
        var didRegisterInvalid = false
        var didRegisterValid = false
        
        textField.validationRules = rules
        XCTAssertNotNil(textField.validationRules)
        
        textField.validateOnInputChange(validationEnabled: true)
        let actions = textField.actions(forTarget: textField, forControlEvent: .editingChanged) ?? []
        XCTAssertFalse(actions.isEmpty)

        textField.validationHandler = { result in
            switch result {
            case .valid: didRegisterValid = true
            case .invalid(_): didRegisterInvalid = true
            }
        }
        
        textField.text = "BCDE"
        let _ = textField.validate() // textField.sendActionsForControlEvents(.EditingChanged) doesn't seem to work in test env
        XCTAssert(didRegisterInvalid)
        XCTAssertFalse(didRegisterValid)
        
        textField.text = "ABCDE"
        let _ = textField.validate()
        XCTAssert(didRegisterInvalid)
        XCTAssert(didRegisterValid)
    }
}
