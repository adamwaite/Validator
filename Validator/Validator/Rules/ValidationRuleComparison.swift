//
//  ValidationRuleComparable.swift
//  Validator
//
//  Created by Adam Waite on 16/07/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import Foundation

struct ValidationRuleComparison<T: Comparable>: ValidationRule {
    
    typealias InputType = T
    
    let min: T
    let max: T
    var failureMessage: String
    
    init(min: T, max: T, failureMessage: String) {
        self.min = min
        self.max = max
        self.failureMessage = failureMessage
    }
    
    func validateInput(input: T) -> Bool {
        return input >= min && input <= max
    }
    
}