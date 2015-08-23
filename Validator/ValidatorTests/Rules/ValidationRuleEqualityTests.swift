/*

 ValidationRuleEqualityTests.swift
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

class ValidationRuleEqualityTests: XCTestCase {

    func testThatItCanValidateEqualityInStrings() {
        
        let rule = ValidationRuleEquality<String>(target: "password", failureError: ValidationError(message: "💣"))
        
        let invalid = Validator.validate(input: "p@ssword", rule: rule)
        XCTAssertFalse(invalid.isValid)

        let valid = Validator.validate(input:"password", rule: rule)
        XCTAssertTrue(valid.isValid)
        
    }

    func testThatItCanValidateEqualityInNumbers() {
        
        let rule = ValidationRuleEquality<Double>(target: 1.0, failureError: ValidationError(message: "💣"))
        
        let invalid = Validator.validate(input: 2.0, rule: rule)
        XCTAssertFalse(invalid.isValid)
        
        let valid = Validator.validate(input: 1.0, rule: rule)
        XCTAssertTrue(valid.isValid)
        
    }
    
    func testThatItCanValidateDynamicProperties() {
        
        let textField = UITextField()
        textField.text = "password"
        let getter: (() -> String) = { return textField.text ?? "" }
        
        let rule = ValidationRuleEquality<String>(dynamicTarget: getter, failureError: ValidationError(message: "💣"))
        
        let invalid = Validator.validate(input: "p@ssword", rule: rule)
        XCTAssertFalse(invalid.isValid)
        
        let valid = Validator.validate(input: "password", rule: rule)
        XCTAssertTrue(valid.isValid)
        
    }
    
}
