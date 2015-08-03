//
//  ValidatableComponent.swift
//  Validator
//
//  Created by Adam Waite on 11/07/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import Foundation

protocol ValidatableInterface {
    typealias InputType
    var inputValue: InputType { get }
}