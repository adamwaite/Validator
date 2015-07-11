//
//  Validatable.swift
//  Validator
//
//  Created by Adam Waite on 09/07/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import Foundation

protocol Validatable {
    func validate<R: ValidationRule>(rule rule: R) -> ValidationResult
    func validate<R: ValidationRule>(rules rules: [R]) -> ValidationResult
}

extension Validatable {
    
    func validate<R: ValidationRule>(rule rule: R) -> ValidationResult {
        return validate(rules: [rule])
    }
    
    func validate<R: ValidationRule>(rules rules: [R]) -> ValidationResult {
        let errors = rules.filter { !$0.validateInput(self as! R.InputType) }.map { $0.failureMessage }
        return errors.isEmpty ? .Valid : .Invalid(errors)
    }
    
}