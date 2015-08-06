//
//  ValidatableInterfaceElement.swift
//  Validator
//
//  Created by Adam Waite on 06/08/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import Foundation

protocol ValidatableInterfaceElement {
    
    typealias InputType: Validatable
    
    var inputValue: InputType { get }
    
    func validate<R: ValidationRule where R.InputType == InputType>(rule r: R) -> ValidationResult
    
    func validate(rules rs: ValidationRuleSet<InputType>) -> ValidationResult

}

extension ValidatableInterfaceElement {
    
    func validate<R: ValidationRule where R.InputType == InputType>(rule r: R) -> ValidationResult {
        return inputValue.validate(rule: r)
    }
    
    func validate(rules rs: ValidationRuleSet<InputType>) -> ValidationResult {
        return inputValue.validate(rules: rs)
    }
    
}