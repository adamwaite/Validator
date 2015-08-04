//
//  Validatables.swift
//  Validator
//
//  Created by Adam Waite on 01/08/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import Foundation

protocol Validatable {
    
    func validate<R: ValidationRule where R.InputType == Self>(rule r: R) -> ValidationResult
    
    func validate(rules rs: ValidationRuleSet<Self>) -> ValidationResult
    
}

extension Validatable {
    
    func validate<R: ValidationRule where R.InputType == Self>(rule r: R) -> ValidationResult {
        return Validator.validate(input: self, rule: r)
    }
    
    func validate(rules rs: ValidationRuleSet<Self>) -> ValidationResult {
        return Validator.validate(input: self, rules: rs)
    }
    
}

extension String : Validatable {}
extension Int : Validatable {}
extension Double : Validatable {}
extension Float : Validatable {}
extension Array : Validatable {}