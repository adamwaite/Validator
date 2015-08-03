//
//  ValidationRuleLength.swift
//  Validator
//
//  Created by Adam Waite on 10/07/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import Foundation

struct ValidationRuleLength: ValidationRule {
    
    typealias InputType = String
    
    let min: Int
    let max: Int
    var failureMessage: String
    
    init(min: Int = 0, max: Int = Int.max, failureMessage: String) {
        self.min = min
        self.max = max
        self.failureMessage = failureMessage
    }
    
    func validateInput(input: String) -> Bool {
        return input.characters.count >= min && input.characters.count <= max
    }

}