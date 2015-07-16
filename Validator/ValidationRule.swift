//
//  ValidationRule.swift
//  Validator
//
//  Created by Adam Waite on 09/07/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import Foundation

protocol ValidationRule {
    typealias ValidatableType
    func validateInput(input: ValidatableType) -> Bool
    var failureMessage: String { get }
}