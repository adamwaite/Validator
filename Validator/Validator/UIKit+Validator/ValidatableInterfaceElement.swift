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

public protocol ValidatableInterfaceElement: AnyObject {
    
    associatedtype InputType: Validatable
    
    var inputValue: InputType? { get }
    
    func validate<R: ValidationRule where R.InputType == InputType>(rule r: R) -> ValidationResult
    
    func validate(rules rs: ValidationRuleSet<InputType>) -> ValidationResult

    func validate() -> ValidationResult
    
    func validateOnInputChange(validationEnabled: Bool)
    
}

private var ValidatableInterfaceElementRulesKey: UInt8 = 0
private var ValidatableInterfaceElementHandlerKey: UInt8 = 0

private final class Box<T>: NSObject {
    let thing: T
    init(thing t: T) { thing = t }
}

extension ValidatableInterfaceElement {

    public typealias ValidationHandler = ValidationResult -> Void

    public var validationRules: ValidationRuleSet<InputType>? {
        get {
            guard let boxed: Box<ValidationRuleSet<InputType>>? = objc_getAssociatedObject(self, &ValidatableInterfaceElementRulesKey) as? Box<ValidationRuleSet<InputType>>? else { return nil }
            return boxed?.thing
        }
        set(newValue) {
            if let n = newValue {
                let boxed = Box<ValidationRuleSet<InputType>>(thing: n)
                objc_setAssociatedObject(self, &ValidatableInterfaceElementRulesKey, boxed, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    public var validationHandler: ValidationHandler? {
        get {
            guard let boxed: Box<ValidationHandler>? = objc_getAssociatedObject(self, &ValidatableInterfaceElementHandlerKey) as? Box<ValidationHandler>? else { fatalError("") }
            return boxed?.thing
        }
        set(newValue) {
            if let n = newValue {
                let boxed = Box<ValidationHandler>(thing: n)
                objc_setAssociatedObject(self, &ValidatableInterfaceElementHandlerKey, boxed, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    public func validate<R: ValidationRule where R.InputType == InputType>(rule r: R) -> ValidationResult {
        let result = Validator.validate(input: inputValue, rule: r)
        if let h = validationHandler { h(result) }
        return result
    }
    
    public func validate(rules rs: ValidationRuleSet<InputType>) -> ValidationResult {
        let result = Validator.validate(input: inputValue, rules: rs)
        if let h = validationHandler { h(result) }
        return result
    }
    
    public func validate() -> ValidationResult {
        guard let attachedRules = validationRules else { fatalError("Validator Error: attempted to validate without attaching rules") }
        return validate(rules: attachedRules)
    }
    
}