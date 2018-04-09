/*

 ValidatableInterfaceElement.swift
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
import ObjectiveC

/**
 
 A user input UI element conforming to `ValidatableInterfaceElement` may 
 validate it's inputValue (e.g. a `UITextField`s `text`) with a validation rule,
 or mutiple validation rules contained in a `ValidationRuleSet`.
 
 A `ValidatableInterfaceElement` may also be registered to observe and validate 
 on input change, optionally executing a closure containing the validation result. 
 
 - Important: 
 The protocol extension implements most of the desired behaviour.
 The required explicit implmentations in your types are as follows:
    - `InputType`: The associated validatable type.
    - `inputValue`: A getter to access the input to validate.
    - `validateOnInputChange`: A means to register, observe and validate the 
    input as it changes.
 See UITextField+ValidatableInterfaceElement.swift for a better idea.
 
 */
public protocol ValidatableInterfaceElement: AnyObject {
    
    /**
     
     The `Validatable` input type of the UI element (e.g. `String` in `UITextField`)
     
     */
    associatedtype InputType: Validatable
    
    /**
     
     The input to pass through validation (e.g. `text` in `UITextField`)
     
     */
    var inputValue: InputType? { get }
    
    /**
     
     A closure executed when the UI element is validated.
     
     */
    var validationHandler: ((ValidationResult) -> Void)? { get set }
    
    
    /**
     
     Validates the receiver's input against a `ValidationRule`.
     
     - Parameters:
        - rule: The rule used to validate the receiver's input.
     
     - Returns:
     A validation result.
     
     */
    func validate<R: ValidationRule>(rule r: R) -> ValidationResult
    
    /**
     
     Validates the receiver's input against a `ValidationRuleSet`.
     
     - Parameters:
        - rules: The rules used to validate the receiver's input.
     
     - Returns:
     A validation result.
     
     */
    func validate(rules: ValidationRuleSet<InputType>) -> ValidationResult
    
    /**
     
     Registers the element to validate it's input when it changes.
     
     - Parameters:
        - enabled: `true` to start observation, `false` to end observation.
     
     */
    func validateOnInputChange(enabled: Bool)
    
}

private var ValidatableInterfaceElementRulesKey: UInt8 = 0
private var ValidatableInterfaceElementHandlerKey: UInt8 = 0

extension ValidatableInterfaceElement {

    public var validationRules: ValidationRuleSet<InputType>? {
        get {
            return objc_getAssociatedObject(self, &ValidatableInterfaceElementRulesKey) as? ValidationRuleSet<InputType>
        }
        set(newValue) {
            if let n = newValue {
                objc_setAssociatedObject(self, &ValidatableInterfaceElementRulesKey, n as AnyObject, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    public var validationHandler: ((ValidationResult) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &ValidatableInterfaceElementHandlerKey) as? (ValidationResult) -> Void
        }
        set(newValue) {
            if let n = newValue {
                objc_setAssociatedObject(self, &ValidatableInterfaceElementHandlerKey, n as AnyObject, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    public func validate<R: ValidationRule>(rule r: R) -> ValidationResult {
        guard let value = inputValue as? R.InputType else { return .invalid([r.error]) }
        let result = Validator.validate(input: value, rule: r)
        validationHandler?(result)
        return result
    }
    
    public func validate(rules rs: ValidationRuleSet<InputType>) -> ValidationResult {
        let result = Validator.validate(input: inputValue, rules: rs)
        validationHandler?(result)
        return result
    }
    
    @discardableResult public func validate() -> ValidationResult {
        guard let attachedRules = validationRules else {
            #if DEBUG
            print("Validator Error: attempted to validate without attaching rules")
            #endif
            return .valid
        }
        return validate(rules: attachedRules)
    }
    
}
