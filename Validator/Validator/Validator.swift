/*

 Validator.swift
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
 
 `Validator` provides a set of static functions to validate a given input
 against a validation rule, or multiple validation rules.
 
 */
public struct Validator {
    
    /**
     
     Validates a given input against a validation rule.
     
     - Parameters:
        - input: The input to be validated.
        - rule: The validation rule.
     
     - Returns:
     A validation result.
     
     */
    public static func validate<R: ValidationRule>(input: R.InputType?, rule: R) -> ValidationResult {
        
        var ruleSet = ValidationRuleSet<R.InputType>()
        ruleSet.add(rule: rule)
        return Validator.validate(input: input, rules: ruleSet)
    }
    
    /**
     
     Validates a given input against mutiple validation rules in a set.
     
     - Parameters:
        - input: The input to be validated.
        - rules: Multiple validation rules in a set.
     
     - Returns:
     A validation result.
     
     */
    public static func validate<T>(input: T?, rules: ValidationRuleSet<T>) -> ValidationResult {
        let errors = rules.rules.filter { !$0.validate(input: input) }.map { $0.error }
        return errors.isEmpty ? .valid : .invalid(errors)
    }
    
}
