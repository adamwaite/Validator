/*

 ValidationRuleSet.swift
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
 
 The `ValidationRuleSet` struct contains multiple validation rules with the same
 associated type (`InputType`).
 
 */
public struct ValidationRuleSet<InputType> {
    
    /**
     
     Initializes an empty validation rule set.
     
     */
    public init() {
    
    }
    
    /**
     
     Initializes a `ValidationRuleSet` with a set of validation rules.
     
     - Parameters:
        - rules: An array of `ValidationRule`s where the associated type matches
        the `InputType` of the rule set under initialization.
     
     */
    public init<R: ValidationRule>(rules: [R]) where R.InputType == InputType {
        self.rules = rules.map(AnyValidationRule.init)
    }
    
    /**
     
     An array of type erased validation rules.
     
     */
    internal var rules = [AnyValidationRule<InputType>]()
    
    
    /**
     
     Appends a validation rule to the set.
     
     - Parameters:
        - rule: Validation rule to be appended.
     
     */
    public mutating func add<R: ValidationRule>(rule: R) where R.InputType == InputType {
        let anyRule = AnyValidationRule(base: rule)
        rules.append(anyRule)
    }
    
}
