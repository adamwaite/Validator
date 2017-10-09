/*

 ValidationRuleEquality.swift
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
 
 `ValidationRuleEquality` validates a `Equatable` type `T` is equal to another
 value. A value may be passed with the initialiser to compare against, or a
 closure may be passed to return a value to compare against if it's likely to 
 change (like a text field's text).
 
 ```
 // Concrete
 ValidationRuleEquality<Int>(target: 3, error: error)
 
 // Dynamic:
 func getPassword() -> String { return passwordField.text ?? "" }
 let passwordsMatch = ValidationRuleEquality<String>(dynamicTarget: getPassword, error: nonMatchError)
 ```
 
 */
public struct ValidationRuleEquality<T: Equatable>: ValidationRule {

    public typealias InputType = T
    
    public let error: Error
    
    /**
     
     A value to compare an input against.
     
     */
    let target: T?
    
    /**
     
     A closure that returns a value to compare an input against.
     
     */
    let dynamicTarget: (() -> T)?
    
    /**
     
     Initializes a `ValidationRuleEquality` with a value to compare an input 
     against, and an error describing a failed validation.
     
     - Parameters:
        - target: A value to compare an input against.
        - error: An error describing a failed validation.
     
     */
    public init(target: T, error: Error) {
        self.target = target
        self.error = error
        self.dynamicTarget = nil
    }
    
    /**
     
     Initializes a `ValidationRuleEquality` with a closure that returns a value 
     to compare an input against, and an error describing a failed validation.
     
     - Parameters:
     - target: A closure that returns a value to compare an input against.
     - error: An error describing a failed validation.
     
     */
    public init(dynamicTarget: @escaping (() -> T), error: Error) {
        self.dynamicTarget = dynamicTarget
        self.error = error
        self.target = nil
    }
  
    /**
     
     Validates the input.
     
     - Parameters:
        - input: Input to validate.
     
     - Returns:
     true if the input equals the target.
     
     */
    public func validate(input: T?) -> Bool {
        if let dynamicTarget = dynamicTarget {
            return input == dynamicTarget()
        }
        
        guard let target = target else { return false }
        return input == target
    }
    
}
