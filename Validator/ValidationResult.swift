//
//  ValidationResult.swift
//  Validator
//
//  Created by Adam Waite on 09/07/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import Foundation

enum ValidationResult {
    case Valid
    case Invalid([String])
    var isValid: Bool { return self == .Valid }
}

extension ValidationResult: Equatable {}
func ==(lhs: ValidationResult, rhs: ValidationResult) -> Bool {
    switch (lhs, rhs) {
    case (.Valid, .Valid): return true
    case (.Invalid(let a), .Invalid(let b)) where a == b: return true
    default: return false
    }
}