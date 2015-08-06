//
//  ValidationRuleSet.swift
//  Validator
//
//  Created by Adam Waite on 03/08/2015.
//  Copyright (c) 2015 adamjwaite.co.uk. All rights reserved.
//

import Foundation

struct ValidationRuleSet<InputType> {
    
    var rules = [AnyValidationRule<InputType>]()
    
    mutating func addRule<R: ValidationRule where R.InputType == InputType>(rule: R) {
        let anyRule = AnyValidationRule(base: rule)
        rules.append(anyRule)
    }
    
}