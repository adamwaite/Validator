//
//  Error.swift
//  Example
//
//  Created by Adam Waite on 29/10/2016.
//  Copyright © 2016 adamjwaite.co.uk. All rights reserved.
//

import Foundation

struct ValidationError: Error {
    
    public let message: String
    
    public init(message m: String) {
        message = m
    }
}
