//
//  UISlider+Validator.swift
//  Validator
//
//  Created by Adam Waite on 04/08/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import UIKit

extension UISlider: ValidatableInterfaceElement {
    
    typealias InputType = Float
    
    var inputValue: Float { return value ?? 0 }
    
    func validateOnChangeWithRules(rules: ValidationRuleSet<InputType>, change: ValidationResult -> ()) {
        ValidatableInterfaceObserver.instance.observeInterfaceElement(self, rules: rules, change: change)
        addTarget(self, action: "validateInterfaceElement:", forControlEvents: .ValueChanged)
    }
    
    @objc private func validateInterfaceElement(sender: UITextField) {
        ValidatableInterfaceObserver.instance.validateInterfaceElement(sender)
    }
    
}