//
//  ValidatorExample.swift
//  Validator
//
//  Created by Adam Waite on 03/08/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import Foundation

struct ValidatorExample<InputType> {
    
    let name: String
    let summary: String
    let rules: ValidationRuleSet<InputType>
    
}