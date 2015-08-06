//
//  Validator.swift
//  Validator
//
//  Created by Adam Waite on 16/07/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import Foundation

struct Validator {
    
    static func validate<InputType, R: ValidationRule where InputType == R.InputType>(input i: InputType, rule r: R) -> ValidationResult {
        var ruleSet = ValidationRuleSet<R.InputType>()
        ruleSet.addRule(r)
        return Validator.validate(input: i, rules: ruleSet)
    }
    
    static func validate<InputType>(input i: InputType, rules rs: ValidationRuleSet<InputType>) -> ValidationResult {
        let errors = rs.rules.filter { !$0.validateInput(i) }.map { $0.failureMessage }
        return errors.isEmpty ? .Valid : .Invalid(errors)
    }
    
}