//
//  ValidatableNumeric.swift
//  Validator
//
//  Created by Adam Waite on 10/07/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import Foundation

protocol ValidatableNumeric {
    var floatValue: Float { get }
}

extension Int: ValidatableNumeric {
    var floatValue: Float { return Float(self) }
}

extension Double: ValidatableNumeric {
    var floatValue: Float { return Float(self) }
}

extension Float: ValidatableNumeric {
    var floatValue: Float { return Float(self) }
}