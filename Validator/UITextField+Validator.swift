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
        validatorEvaluation = ValidatableInterfaceEvaluation(rules: rules, change: change)
        addTarget(self, action: "validateUITextField:", forControlEvents: .EditingChanged)
    }
    
    @objc private func validateUITextField(sender: UITextField) {
        sender.validateInputValue()
    }

}