//
//  ValidationRule.swift
//  Validator
//
//  Created by Adam Waite on 09/07/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import Foundation

protocol ValidationRule {
    typealias InputType
    func validateInput(input: InputType) -> Bool
    var failureMessage: String { get }
}

struct AnyValidationRule<InputType>: ValidationRule {
    
    private let baseValidateInput: (InputType) -> Bool
    let failureMessage: String
    
    init<R: ValidationRule where R.InputType == InputType>(base: R) {
        baseValidateInput = base.validateInput
        failureMessage = base.failureMessage
    }
    
    func validateInput(input: InputType) -> Bool {
        return baseValidateInput(input)
    }
    
}
