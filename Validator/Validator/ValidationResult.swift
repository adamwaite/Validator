/*

 ValidationResult.swift
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
 
 The ValidationResult enum desribes the result of a validation. It may take one 
 of two forms: valid (a passed validation), or invalid (a failed validation).
 
 */
public enum ValidationResult {
    
    /**
     
     A successful validation (an input satisfies the condition in a rule).
    
     */
    case valid
    
    /**
     
     A failed validation (an input does not satisfy the condition in a rule). 

     The .invalid case has an associated collection of validation errors.
     
     */
    case invalid([Error])
    
    /**
 
     True if the result is valid
     
     */
    public var isValid: Bool { return self == .valid }

    
    /**
     
     Merges the receiving validation rule with another.
     
     ```
     .valid.merge(.valid) // = .valid
     .valid.merge(.invalid([err])) // = .invalid([err])
     .invalid([err1]).merge(.invalid([err2]) // = .invalid([err1, err2])
     ```
     
     - Parameters:
        - result: The result to merge into the receiver.
     
     - Returns:
     Merged validation result.
     
     */
    public func merge(with result: ValidationResult) -> ValidationResult {
        switch self {
        case .valid: return result
        case .invalid(let errorMessages):
            switch result {
            case .valid:
                return self
            case .invalid(let errorMessagesAnother):
                return .invalid([errorMessages, errorMessagesAnother].flatMap { $0 })
            }
        }
    }
    
    /**
     
     Merges the receiving validation rule with multiple others.
     
     - Parameters:
        - results: The results to merge the receiver.
     
     - Returns:
     Merged validation result.
     
     */
    public func merge(with results: [ValidationResult]) -> ValidationResult {
        return results.reduce(self) { return $0.merge(with: $1) }
    }
    
    /**
     
     Merges multiple validation rules together.
     
     - Parameters:
        - results: The results to merge.
     
     - Returns:
     Merged validation result.
     
     */
    public static func merge(results: [ValidationResult]) -> ValidationResult {
        return ValidationResult.valid.merge(with: results)
    }
}

extension ValidationResult: Equatable {}
public func ==(lhs: ValidationResult, rhs: ValidationResult) -> Bool {
    switch (lhs, rhs) {
    case (.valid, .valid): return true
    case (.invalid(_), .invalid(_)): return true
    default: return false
    }
}
