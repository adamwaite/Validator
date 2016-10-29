/*

 ValidationRuleURLTests.swift
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

class ValidationRuleContainsTests: XCTestCase {
    
    func testThatItCanValidateContainsString() {
        
        let rule = ValidationRuleContains<String, [String]>(sequence: ["hello", "hi", "hey"], error: testError)
        
        for notInSequence in ["adam", "😋", "HEY"] {
            let invalid = Validator.validate(input: notInSequence, rule: rule)
            XCTAssertFalse(invalid.isValid)
        }
        
        for inSequence in ["hello", "hi", "hey"] {
            let valid = Validator.validate(input: inSequence, rule: rule)
            XCTAssertTrue(valid.isValid)
        }
    }
    
    func testThatItCanValidateContainsInt() {
        
        let rule = ValidationRuleContains<Int, [Int]>(sequence: [1, 2, 3], error: testError)
        
        for notInSequence in [4, 5, 6] {
            let invalid = Validator.validate(input: notInSequence, rule: rule)
            XCTAssertFalse(invalid.isValid)
        }
        
        for inSequence in [1, 2, 3] {
            let valid = Validator.validate(input: inSequence, rule: rule)
            XCTAssertTrue(valid.isValid)
        }
    }
}
