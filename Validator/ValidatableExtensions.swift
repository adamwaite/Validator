//
//  ValidatableExtensions.swift
//  Validator
//
//  Created by Adam Waite on 09/07/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import Foundation

// TODO: Is there a way to so this in the protocol extension?

extension String: Validatable {
    typealias ValidatableType = String
}

extension Int: Validatable {
    typealias ValidatableType = Int
}

extension Double: Validatable {
    typealias ValidatableType = Double
}

extension Float: Validatable {
    typealias ValidatableType = Float
}

extension Array: Validatable {
    typealias ValidatableType = Array
}