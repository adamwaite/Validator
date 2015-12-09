/*

 UISliderValidatorTests.swift
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

import Foundation

import XCTest
@testable import Validator

class UISliderValidatorTests: XCTestCase {
    
    func testThatItProvidesAnInputValue() {
        
        let slider = UISlider()
        slider.maximumValue = 10.0
        slider.value = 5.0
        
        XCTAssertTrue(slider.inputValue == Float(5.0))
        
    }
    
    func testThatItCanValidateInputNumbers() {
        
        let slider = UISlider()
        slider.maximumValue = 10.0

        let rule = ValidationRuleComparison<Float>(min: 2.0, max: 7.0, failureError: testError)

        slider.value = 1.0
        
        let tooSmall = slider.validate(rule: rule)
        XCTAssertFalse(tooSmall.isValid)
        
        slider.value = 8.0
        
        let tooBig = slider.validate(rule: rule)
        XCTAssertFalse(tooBig.isValid)

        slider.value = 4.0
        XCTAssertTrue(slider.inputValue == 4.0)
        
        let valid = slider.validate(rule: rule)
        XCTAssertTrue(valid.isValid)
        
    }
}