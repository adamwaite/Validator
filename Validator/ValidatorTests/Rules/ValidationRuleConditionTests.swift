/*

 ValidationRuleConditionTests.swift
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

class ValidationRuleConditionTests: XCTestCase {
    
//    func testThatItCanValidateCustomConditions() {
//
//        let ruleA = ValidationRuleCondition<String>(failureError: testError) { $0?.range(of: "A") == nil }
//        
//        let invalidA = Validator.validate(input: "invAlid", rule: ruleA)
//        XCTAssertFalse(invalidA.isValid)
//        
//        let validA = Validator.validate(input: "😀", rule: ruleA)
//        XCTAssertTrue(validA.isValid)
//        
//        let ruleB = ValidationRuleCondition<[Int]>(failureError: testError) { $0!.reduce(0, +) > 50 }
//
//        let invalidB = Validator.validate(input: [40, 1, 5], rule: ruleB)
//        XCTAssertFalse(invalidB.isValid)
//        
//        let validB = Validator.validate(input: [45, 1, 5], rule: ruleB)
//        XCTAssertTrue(validB.isValid)
//        
//    }
    
}
