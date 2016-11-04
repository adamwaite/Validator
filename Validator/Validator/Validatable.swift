/*

 Validatable.swift
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
 
 A type conforming to `Validatable` can be validated against a `ValidationRule`
 or a `ValidationRuleSet` (with an equal `InputType`).
 
 ```
 extension String : Validatable {}
 
 "Hello world!".validate(rule: someRule)
 ```
 
 - Important:
 The protocol extension implements the desired behaviour.
 Methods should not be implemented explicitly in the conforming type.
 
 */
public protocol Validatable {
    
    /**
     
     Validates the receiver against a `ValidationRule`.
     
     - Parameters:
        - rule: The rule used to validate the receiver.
     
     - Returns:
     A validation result.
     
     */
    func validate<R: ValidationRule>(rule: R) -> ValidationResult where R.InputType == Self
    
    /**
     
     Validates the receiver against a `ValidationRuleSet`.
     
     - Parameters:
        - rules: The rules used to validate the receiver.
     
     - Returns:
     A validation result.
     
     */
    func validate(rules: ValidationRuleSet<Self>) -> ValidationResult
    
}

extension Validatable {
    
    public func validate<R: ValidationRule>(rule: R) -> ValidationResult where R.InputType == Self {
        return Validator.validate(input: self, rule: rule)
    }
    
    public func validate(rules: ValidationRuleSet<Self>) -> ValidationResult {
        return Validator.validate(input: self, rules: rules)
    }
    
}

extension String : Validatable {}
extension Int : Validatable {}
extension Double : Validatable {}
extension Float : Validatable {}
extension Array : Validatable {}
extension Date : Validatable {}
