//
//  Validatable.swift
//  Validator
//
//  Created by Adam Waite on 09/07/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import Foundation

protocol Validatable {
    typealias ValidatableType
    func validate<R: ValidationRule where R.ValidatableType == Self>(rule rule: R) -> ValidationResult
    func validate<R: ValidationRule where R.ValidatableType == Self>(rules rules: [R]) -> ValidationResult
}

extension Validatable {
        
    func validate<R: ValidationRule where R.ValidatableType == Self>(rule rule: R) -> ValidationResult {
        return validate(rules: [rule])
    }
    
    func validate<R: ValidationRule where R.ValidatableType == Self>(rules rules: [R]) -> ValidationResult {
        let errors = rules.filter { !$0.validateInput(self) }.map { $0.failureMessage }
        return errors.isEmpty ? .Valid : .Invalid(errors)
    }
    
}