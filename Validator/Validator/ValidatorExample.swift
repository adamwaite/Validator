//
//  ValidatorExample.swift
//  Validator
//
//  Created by Adam Waite on 11/07/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import Foundation

struct ValidatorExample<R: ValidationRule> {
    
    let rule: R
    let title: String
    let summary: String
    
}