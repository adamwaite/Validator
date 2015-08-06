//
//  UITextField+Validator.swift
//  Validator
//
//  Created by Adam Waite on 06/08/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import UIKit

extension UITextField: ValidatableInterfaceElement {
    
    typealias InputType = String
    
    var inputValue: String { return text ?? "" }
    
}