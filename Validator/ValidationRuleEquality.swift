//
//  ValidationRuleEquality.swift
//  Validator
//
//  Created by Adam Waite on 11/07/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import Foundation

struct ValidationRuleEquality<T: Equatable>: ValidationRule {

    typealias InputType = T
    
    let target: T
    let dynamicTarget: (() -> T)?
    let failureMessage: String
    
    init(target: T, failureMessage: String) {
        self.target = target
        self.failureMessage = failureMessage
        self.dynamicTarget = nil
    }
    
    init(dynamicTarget: (() -> T), failureMessage: String) {
        self.target = dynamicTarget()
        self.dynamicTarget = dynamicTarget
        self.failureMessage = failureMessage
    }
    
    func validateInput(input: T) -> Bool {
        if let dT = dynamicTarget {
            return input == dT()
        }
        return input == target
    }
    
}