/*

 ValidationRulePattern.swift
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
 
 `ValidationRulePattern` validates a `String`' against a regular expression which
 may be provided in the form of a `String` or a type conforming to 
 `ValidationRulePattern`.
 
 */
public struct ValidationRulePattern: ValidationRule {
    
    public typealias InputType = String
    public let error: Error

    /**
     
     A regular expression to evaluate an input against.
     
     */
    public let pattern: String
    
    /**
     
     Initializes a `ValidationRulePattern` with a regular expression in string 
     format, and an error describing a failed
     validation.
     
     - Parameters:
        - pattern: A regular expression in string format to evaluate an input 
        against.
        - error: An error describing a failed validation.
     
     */
    public init(pattern: String, error: Error) {
        self.pattern = pattern
        self.error = error
    }
    
    /**
     
     Initializes a `ValidationRulePattern` with a regular expression in 
     ValidationPattern format, and an error describing a failed validation.
     
     - Parameters:
        - pattern: A regular expression in `ValidationPattern` format to
        evaluate an input against. The string value of the pattern is used for
        evaluation.
        - error: An error describing a failed validation.
     
     */
    public init(pattern: ValidationPattern, error: Error) {
        self.init(pattern: pattern.pattern, error: error)
    }
    
    /**
     
     Validates the input.
     
     - Parameters:
     - input: Input to validate.
     
     - Returns:
     true if the input matched the regular expression.
     
     */
    public func validate(input: String?) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: input)
    }
    
}
