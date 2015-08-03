//
//  ValidationRuleCondition.swift
//  Validator
//
//  Created by Adam Waite on 10/07/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import Foundation

struct ValidationRuleCondition<T>: ValidationRule {
    
    typealias InputType = T
    
    let condition: T -> Bool
    let failureMessage: String
        
    init(failureMessage: String, condition: (T -> Bool)) {
        self.condition = condition
        self.failureMessage = failureMessage
    }
    
    func validateInput(input: T) -> Bool {
        return condition(input)
    }
    
}