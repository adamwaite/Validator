//
//  ValidatableInterfaceElement.swift
//  Validator
//
//  Created by Adam Waite on 06/08/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import Foundation
import ObjectiveC

typealias ValidationHandler = ValidationResult -> ()

protocol ValidatableInterfaceElement: AnyObject {
    
    typealias InputType: Validatable
    
    var inputValue: InputType { get }
    
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
    
    var validationRules: ValidationRuleSet<InputType>? {
        get {
            let boxed: Box<ValidationRuleSet<InputType>>? = objc_getAssociatedObject(self, &ValidatableInterfaceElementRulesKey) as! Box<ValidationRuleSet<InputType>>?
            return boxed?.thing
        }
        set(newValue) {
            if let n = newValue {
                let boxed = Box<ValidationRuleSet<InputType>>(thing: n)
                objc_setAssociatedObject(self, &ValidatableInterfaceElementRulesKey, boxed, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    var validationHandler: ValidationHandler? {
        get {
            let boxed: Box<ValidationHandler>? = objc_getAssociatedObject(self, &ValidatableInterfaceElementHandlerKey) as! Box<ValidationHandler>?
            return boxed?.thing
        }
        set(newValue) {
            if let n = newValue {
                let boxed = Box<ValidationHandler>(thing: n)
                objc_setAssociatedObject(self, &ValidatableInterfaceElementHandlerKey, boxed, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    func validate<R: ValidationRule where R.InputType == InputType>(rule r: R) -> ValidationResult {
        let result = inputValue.validate(rule: r)
        if let h = validationHandler { h(result) }
        return result
    }
    
    func validate(rules rs: ValidationRuleSet<InputType>) -> ValidationResult {
        let result = inputValue.validate(rules: rs)
        if let h = validationHandler { h(result) }
        return result
    }
    
    func validate() -> ValidationResult {
        guard let attachedRules = validationRules else { fatalError("Validator Error: attempted to validate without attaching rules") }
        return validate(rules: attachedRules)
    }
    
}