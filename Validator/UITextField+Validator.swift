//
//  UITextField+Validator.swift
//  Validator
//
//  Created by Adam Waite on 11/07/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import UIKit

extension UITextField: ValidatableInterface {
    typealias InputType = String
    var inputValue: String { return text ?? "" }
}