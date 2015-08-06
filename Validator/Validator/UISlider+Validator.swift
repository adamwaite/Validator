//
//  UISlider+Validator.swift
//  Validator
//
//  Created by Adam Waite on 06/08/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import UIKit

extension UISlider: ValidatableInterfaceElement {
    
    typealias InputType = Float
    
    var inputValue: Float { return value }
    
}