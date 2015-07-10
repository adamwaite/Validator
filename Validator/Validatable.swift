//
//  Validatable.swift
//  Validator
//
//  Created by Adam Waite on 09/07/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import Foundation

protocol Validatable {
    func validate(rule rule: ValidationRule) -> ValidationResult
    func validate(rules rules: [ValidationRule]) -> ValidationResult
}

extension Validatable {
    
    func validate(rule rule: ValidationRule) -> ValidationResult {
        return validate(rules: [rule])
    }
    
    func validate(rules rules: [ValidationRule]) -> ValidationResult {
        var errors = [String]()
        for rule in rules {
            if !rule.validateInput(self) {
                errors.append(rule.failureMessage)
            }
        }
        return errors.isEmpty ? .Valid : .Invalid(errors)
    }
    
}