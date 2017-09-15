/*

 ValidationRuleLengthTests.swift
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

class ValidationRuleLengthTests: XCTestCase {
    
    func testThatItCanValidateMinLength() {
        
        let rule = ValidationRuleLength(min: 5, error: testError)
        
        let tooShort = Validator.validate(input: "aaaa", rule: rule)
        XCTAssertFalse(tooShort.isValid)
        
        let valid = Validator.validate(input: "aaaaa", rule: rule)
        XCTAssertTrue(valid.isValid)
        
    }
    
    func testThatItCanValidateMaxLength() {
        
        let rule = ValidationRuleLength(max: 5, error: testError)
        
        let tooLong = Validator.validate(input: "aaaaaa", rule: rule)
        XCTAssertFalse(tooLong.isValid)
        
        let valid = Validator.validate(input: "aaaaa", rule: rule)
        XCTAssertTrue(valid.isValid)
        
    }
    
    func testThatItCanValidateRangeLength() {
        
        let rule = ValidationRuleLength(min: 5, max: 10, error: testError)
        
        let tooShort = Validator.validate(input: "aaaa", rule: rule)
        XCTAssertFalse(tooShort.isValid)
    
        let tooLong = Validator.validate(input: "aaaaaaaaaaa", rule: rule)
        XCTAssertFalse(tooLong.isValid)
        
        for input in ["aaaaa", "aaaaaaaaaa", "aaaaaaaa"] {
            let valid = Validator.validate(input: input, rule: rule)
            XCTAssertTrue(valid.isValid)
        }
        
    }

    func testThatItCanValidateEmojiCharacthersMinLength() {
        // NOTE: "🇯🇵".characters.count = 1

        let rule = ValidationRuleLength(min: 2, error: testError)

        let tooShort = Validator.validate(input: "🇯🇵", rule: rule)
        XCTAssertFalse(tooShort.isValid)

        let valid = Validator.validate(input: "🇯🇵🇯🇵", rule: rule)
        XCTAssertTrue(valid.isValid)
    }

    func testThatItCanValidateEmojiCharacthersMaxLength() {
        // NOTE: "🇯🇵".characters.count = 1

        let rule = ValidationRuleLength(max: 2, error: testError)

        let tooLong = Validator.validate(input: "🇯🇵🇯🇵🇯🇵", rule: rule)
        XCTAssertFalse(tooLong.isValid)

        let valid = Validator.validate(input: "🇯🇵🇯🇵", rule: rule)
        XCTAssertTrue(valid.isValid)
    }

    func testThatItCanValidateEmojiUTF8MinLength() {
        // NOTE: "🇯🇵".utf8.count = 8

        let rule = ValidationRuleLength(min: 16, lengthType: .utf8, error: testError)

        let tooShort = Validator.validate(input: "🇯🇵", rule: rule)
        XCTAssertFalse(tooShort.isValid)

        let valid = Validator.validate(input: "🇯🇵🇯🇵", rule: rule)
        XCTAssertTrue(valid.isValid)
    }

    func testThatItCanValidateEmojiUTF8MaxLength() {
        // NOTE: "🇯🇵".utf8.count = 8

        let rule = ValidationRuleLength(max: 16, lengthType: .utf8, error: testError)

        let tooLong = Validator.validate(input: "🇯🇵🇯🇵🇯🇵", rule: rule)
        XCTAssertFalse(tooLong.isValid)

        let valid = Validator.validate(input: "🇯🇵🇯🇵", rule: rule)
        XCTAssertTrue(valid.isValid)
    }

    func testThatItCanValidateEmojiUTF16MinLength() {
        // NOTE: "🇯🇵".utf16.count = 4

        let rule = ValidationRuleLength(min: 8, lengthType: .utf16, error: testError)

        let tooShort = Validator.validate(input: "🇯🇵", rule: rule)
        XCTAssertFalse(tooShort.isValid)

        let valid = Validator.validate(input: "🇯🇵🇯🇵", rule: rule)
        XCTAssertTrue(valid.isValid)
    }

    func testThatItCanValidateEmojiUTF16MaxLength() {
        // NOTE: "🇯🇵".utf16.count = 4

        let rule = ValidationRuleLength(max: 8, lengthType: .utf16, error: testError)

        let tooLong = Validator.validate(input: "🇯🇵🇯🇵🇯🇵", rule: rule)
        XCTAssertFalse(tooLong.isValid)

        let valid = Validator.validate(input: "🇯🇵🇯🇵", rule: rule)
        XCTAssertTrue(valid.isValid)
    }

    func testThatItCanValidateEmojiUnicodeScalarsMinLength() {
        // NOTE: "🇯🇵".unicodeScalars.count = 2

        let rule = ValidationRuleLength(min: 4, lengthType: .unicodeScalars, error: testError)

        let tooShort = Validator.validate(input: "🇯🇵", rule: rule)
        XCTAssertFalse(tooShort.isValid)

        let valid = Validator.validate(input: "🇯🇵🇯🇵", rule: rule)
        XCTAssertTrue(valid.isValid)
    }

    func testThatItCanValidateEmojiUnicodeScalarsMaxLength() {
        // NOTE: "🇯🇵".unicodeScalars.count = 2

        let rule = ValidationRuleLength(max: 4, lengthType: .unicodeScalars, error: testError)

        let tooLong = Validator.validate(input: "🇯🇵🇯🇵🇯🇵", rule: rule)
        XCTAssertFalse(tooLong.isValid)

        let valid = Validator.validate(input: "🇯🇵🇯🇵", rule: rule)
        XCTAssertTrue(valid.isValid)
    }
}
