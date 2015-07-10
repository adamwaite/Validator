//
//  ValidationRuleRange.swift
//  Validator
//
//  Created by Adam Waite on 10/07/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import Foundation
import Darwin

struct ValidationRuleRange: ValidationRule {
    
    let min: Float
    let max: Float
    var failureMessage: String
    
    init(min: Float = 0, max: Float = FLT_MAX, failureMessage: String) {
        self.min = min
        self.max = max
        self.failureMessage = failureMessage
    }
    
    func validateInput(input: Validatable) -> Bool {
        switch input {
        case let s as String: return Float(s.characters.count) >= min && Float(s.characters.count) <= max
        case let numeric as ValidatableNumeric: return numeric.floatValue >= min && numeric.floatValue <= max
        default: return false
        }
    }

}