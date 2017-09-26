//
//  CaseValidationPattern.swift
//  Validator
//
//  Created by Adam Waite on 31/10/2016.
//  Copyright © 2016 adamjwaite.co.uk. All rights reserved.
//

import Foundation

/**
 
 CaseValidationPattern is used to ensure an input contains at least 1 uppercase,
 or lowercase letter.
 
 */
public enum CaseValidationPattern: String, ValidationPattern {
    
    case uppercase, lowercase
    
    public var pattern: String {
        switch self {
        case .uppercase: return "^.*?[A-Z].*?$"
        case .lowercase: return "^.*?[a-z].*?$"
        }
    }
}
