//
//  ValidationRuleRange.swift
//  Validator
//
//  Created by Adam Waite on 10/07/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import Foundation
import Darwin

struct ValidationRuleRange<T>: ValidationRule {
    
    typealias InputType = T
    
    let min: Float
    let max: Float
    var failureMessage: String
    
    init(min: Float = 0, max: Float = FLT_MAX, failureMessage: String) {
        self.min = min
        self.max = max
        self.failureMessage = failureMessage
    }
    
    func validateInput(input: T) -> Bool {
        switch input {
        case let s as String: return inRange(s.characters.count)
        case let n as ValidatableNumeric: return inRange(n)
        default: return false
        }
    }
    
    private func inRange(n: ValidatableNumeric) -> Bool {
        return n.floatValue >= min && n.floatValue <= max
    }

}