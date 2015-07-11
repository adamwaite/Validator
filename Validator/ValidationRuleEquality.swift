//
//  ValidationRuleEquality.swift
//  Validator
//
//  Created by Adam Waite on 11/07/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import Foundation

struct ValidationRuleEquality<T: Equatable>: ValidationRule {
    
    typealias InputType = [T]
    
    let failureMessage: String
    
    init(failureMessage: String) {
        self.failureMessage = failureMessage
    }
    
    func validateInput(input: [T]) -> Bool {
        switch input {
        case let input where input.count >= 2: return input.filter { $0 == input.first! }.count > 1
        default: return false
        }
    }
    
}