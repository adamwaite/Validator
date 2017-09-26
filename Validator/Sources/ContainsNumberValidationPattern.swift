//
//  ContainsNumberValidationPattern.swift
//  Validator
//
//  Created by Adam Waite on 31/10/2016.
//  Copyright © 2016 adamjwaite.co.uk. All rights reserved.
//

import Foundation

public struct ContainsNumberValidationPattern: ValidationPattern {
    
    public init() {
        
    }
    
    public var pattern: String {
        return ".*\\d.*"
    }
}
