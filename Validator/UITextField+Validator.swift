//
//  UITextField+Validator.swift
//  Validator
//
//  Created by Adam Waite on 11/07/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import UIKit

extension UITextField: ValidatableInterfaceElement {
    
    typealias InputType = String
    
    var inputValue: String { return text ?? "" }
    
    func validateOnChangeWithRules(rules: ValidationRuleSet<InputType>, change: ValidationResult -> ()) {
        ValidatableInterfaceObserver.instance.observeInterfaceElement(self, rules: rules, change: change)
        addTarget(self, action: "validateInterfaceElement:", forControlEvents: .EditingChanged)
    }
    
    @objc private func validateInterfaceElement(sender: UITextField) {
        ValidatableInterfaceObserver.instance.validateInterfaceElement(sender)
    }

}