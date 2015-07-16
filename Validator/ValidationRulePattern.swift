//
//  ValidationRulePattern.swift
//  Validator
//
//  Created by Adam Waite on 11/07/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import Foundation

enum ValidationPattern: String {
    case EmailAddress = "^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-+]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z‌​]{2,4})$"
    case ContainsNumber = ".*\\d.*"
}

struct ValidationRulePattern: ValidationRule {
    
    typealias ValidatableType = String
    
    let pattern: String
    var failureMessage: String
    
    init(pattern: String, failureMessage: String) {
        self.pattern = pattern
        self.failureMessage = failureMessage
    }
    
    init(pattern: ValidationPattern, failureMessage: String) {
        self.init(pattern: pattern.rawValue, failureMessage: failureMessage)
    }
    
    func validateInput(input: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluateWithObject(input)
    }
    
}