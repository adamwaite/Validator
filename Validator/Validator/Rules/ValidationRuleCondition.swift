/*

 ValidationRuleCondition.swift
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
 
 `ValidationRuleCondition` validates a type `T` satisfies a condition.
 
 ```
 let rule = ValidationRuleCondition<String>(error: someError) { 
    $0.contains("a") 
 }
 
 "Adam".validate(rule) // .valid
 ```
 
 */
public struct ValidationRuleCondition<T>: ValidationRule {
    
    public typealias InputType = T

    public let error: Error
    
    /**
 
     Condition used to validate the input.
     
     */
    public let condition: (T?) -> Bool
    
    /**
     
     Initializes a `ValidationRuleCondition` with a condition used to validate
     an input, and an error describing a failed validation.
     
     - Parameters:
        - error: An error describing a failed validation.
        - condition: Condition used to validate an input.
     
     */
    public init(error: Error, condition: @escaping ((T?) -> Bool)) {
        self.condition = condition
        self.error = error
    }
    
    /**
     
     Validates the input.
     
     - Parameters:
        - input: Input to validate.
     
     - Returns:
     true if the input satisifies the condition.
     
     */
    public func validate(input: T?) -> Bool {
        return condition(input)
    }
    
}
