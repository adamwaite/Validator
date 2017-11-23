/*

 ValidationRuleLength.swift
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

/**
 
 `ValidationRuleLength` validates a `String`'s character count is greater than 
 or equal to a minimum, less than or equal to a maximum, or sits on or between 
 a minimum and maximum.
 
 */
public struct ValidationRuleLength: ValidationRule {

    /**
     
     `String` text count type.

     */
    public enum LengthType {
        case characters
        case utf8
        case utf16
        case unicodeScalars
    }
    
    public typealias InputType = String

    public var error: Error
    
    /**
     
     The minimum character count an input must have (default 0).
     
     */
    public let min: Int

    /**
     
     The maximum character count an input must have (default Int.max).
     
     */
    public let max: Int

    /**

     The `String` text count type an input most have (default .characters).

     */
    public let lengthType: LengthType

    /**
     
     Initializes a `ValidationRuleLength` with an optionally supplied minimum 
     character count, an optionally supplied maximum character count, and an 
     error describing a failed validation.
     
     - Parameters:
        - min: A minimum character count an input must have (default 0).
        - max: A maximum character count an input must have (default Int.max).
        - lengthType: A `String` text count type an input most have (default .characters).
        - error: An error describing a failed validation.
     
     */
    public init(min: Int = 0, max: Int = Int.max, lengthType: LengthType = .characters, error: Error) {
        self.min = min
        self.max = max
        self.lengthType = lengthType
        self.error = error
    }
    
    /**
     
     Validates the input.
     
     - Parameters:
        - input: Input to validate.

     - Returns:
     true if the input character count is between the minimum and maximum.
     
     */
    public func validate(input: String?) -> Bool {
        guard let input = input else { return false }

        let length: Int
        switch lengthType {
        case .characters: length = input.count
        case .utf8: length = input.utf8.count
        case .utf16: length = input.utf16.count
        case .unicodeScalars: length = input.unicodeScalars.count
        }

        return length >= min && length <= max
    }

}
