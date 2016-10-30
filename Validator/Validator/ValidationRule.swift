/*

 ValidationRule.swift
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
 
 A type conforming to `ValidationRule` describes how to validate an input of an 
 associated type, and an error should the validation fail.
 
 */
public protocol ValidationRule {
    
    /** 
    
    The type of input on which the validation is performed, e.g. `String`
    
    */
    associatedtype InputType
    
    /**
     
     The validate method validates the associated type against a condition, 
     returning true if the validation passes.
     
     - Parameters:
        - input: The input to be validated.
     
     - Returns:
     true if valid.
     
     */
    func validate(input: InputType?) -> Bool
    
    /**
     
     An error to be contained in an `.invalid` `ValidationResult` should an 
     input not satify the condition of the validation described by 
     `validate(input:)`
     
     */
    var error: Error { get }
    
}

internal struct AnyValidationRule<InputType>: ValidationRule {
    
    private let baseValidateInput: (InputType?) -> Bool
    
    let error: Error
    
    init<R: ValidationRule>(base: R) where R.InputType == InputType {
        baseValidateInput = base.validate
        error = base.error
    }
    
    func validate(input: InputType?) -> Bool {
        return baseValidateInput(input)
    }

}
