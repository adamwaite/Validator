/*

 ValidationRuleComparisonTests.swift
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

class ValidationRuleComparisonTests: XCTestCase {

    func testThatItCanValidateUsingAnIntegerRange() {

        let rule = ValidationRuleComparison<Int>(min: 5, max: 10, error: testError)

        let tooSmall = Validator.validate(input: 4, rule: rule)
        XCTAssertFalse(tooSmall.isValid)

        let tooLarge = Validator.validate(input: 11, rule: rule)
        XCTAssertFalse(tooLarge.isValid)

        for n in (5...10) {
            let valid = Validator.validate(input: n, rule: rule)
            XCTAssertTrue(valid.isValid)
        }

    }

    func testThatItCanValidateUsingADoubleRange() {

        let rule = ValidationRuleComparison<Double>(min: 5.0, max: 10.0, error: testError)

        let tooSmall = Validator.validate(input: 4.0, rule: rule)
        XCTAssertFalse(tooSmall.isValid)

        let tooLarge = Validator.validate(input: 10.1, rule: rule)
        XCTAssertFalse(tooLarge.isValid)

        for n in [5.4, 6.2, 7.7, 8.3, 9.1, 10.0] {
            let valid = Validator.validate(input: n, rule: rule)
            XCTAssertTrue(valid.isValid)
        }
        
    }
    
}
