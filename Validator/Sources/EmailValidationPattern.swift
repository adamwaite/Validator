//
//  EmailValidationPattern.swift
//  Validator
//
//  Created by Adam Waite on 31/10/2016.
//  Copyright © 2016 adamjwaite.co.uk. All rights reserved.
//

import Foundation

/**
 
 EmailValidationPattern is used to ensure an input is a valid email address.
 
 https://github.com/adamwaite/Validator/issues/36
 
 */
public enum EmailValidationPattern: ValidationPattern {
    
    case simple
    case standard

    public var pattern: String {
        switch self {
        case .simple: return "^.+@.+\\..+$"
        case .standard: return "^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-+]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z‌​]{2,})$"
        }
    }
}
