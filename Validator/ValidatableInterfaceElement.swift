//
//  ValidatableInterfaceElement.swift
//  Validator
//
//  Created by Adam Waite on 11/07/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import UIKit
import ObjectiveC

protocol ValidatableInterfaceElement: AnyObject {
    
    typealias InputType
    
    var inputValue: InputType { get }
    
    func validateOnChangeWithRules(rules: ValidationRuleSet<InputType>, change: ValidationResult -> ())
    
    func validateInputValue()

}

private var ValidatableInterfaceElementKey = 0

extension ValidatableInterfaceElement {
    
    var validatorEvaluation: ValidatableInterfaceEvaluation<InputType>? {
        get {
            return objc_getAssociatedObject(self, &ValidatableInterfaceElementKey) as! ValidatableInterfaceEvaluation<InputType>?
        }
        set(newValue) {
            objc_setAssociatedObject(self, &ValidatableInterfaceElementKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func validateInputValue() {
        guard let evaluation = validatorEvaluation else {
            print("No ValidatableInterfaceEvaluation set on \(self)")
            return
        }
        
        let rules = evaluation.rules
        let change = evaluation.change
        let result = Validator.validate(input: inputValue, rules: rules)
        
        change(result)
    }
    
}

class ValidatableInterfaceEvaluation<InputType> : NSObject {
    
    let rules: ValidationRuleSet<InputType>
    let change: ValidationResult -> ()
    
    init(rules r: ValidationRuleSet<InputType>, change c: ValidationResult -> ()) {
        rules = r
        change = c
        super.init()
    }
    
}