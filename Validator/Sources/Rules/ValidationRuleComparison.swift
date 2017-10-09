/*

 ValidationRuleComparison.swift
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
 
 `ValidationRuleComparison` validates a `Comparable` type `T` is equal to or 
 between a minimum and maximum value.
 
 */
public struct ValidationRuleComparison<T: Comparable>: ValidationRule {
    
    public typealias InputType = T
    
    public let error: Error
    
    /**
     
     A minimum value an input must equal to or be greater than to pass as valid.
     
     */
    let min: T
    
    /**
     
     A maximum value an input must equal to or be less than to pass as valid.
     
     */
    let max: T
    
    /**
     
     Initializes a `ValidationRuleComparison` with a min and max value for an 
     input comparison, and an error describing a failed validation.
     
     - Parameters:
        - min: A minimum value an input must equal to or be greater than.
        - max: A maximum value an input must equal to or be less than.
        - error: An error describing a failed validation.
     
     */
    public init(min: T, max: T, error: Error) {
        self.min = min
        self.max = max
        self.error = error
    }
    
    /**
     
     Validates the input.
     
     - Parameters:
        - input: Input to validate.
     
     - Returns:
        true if the input is equal to or between the minimum and maximum.
     
     */
    public func validate(input: T?) -> Bool {
        guard let input = input else { return false }
        return input >= min && input <= max
    }
    
}
