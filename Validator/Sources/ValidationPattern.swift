//
//  ValidationPattern.swift
//  Validator
//
//  Created by Adam Waite on 31/10/2016.
//  Copyright © 2016 adamjwaite.co.uk. All rights reserved.
//

import Foundation

/**
 
 Types conforming to `ValidationPattern` provide a means to validate a string 
 using a `ValidationRulePattern` by providing a regular expression for the rule.
 
 See the implementation discussion here: 
 https://github.com/adamwaite/Validator/issues/30
 
 */
public protocol ValidationPattern {
    
    /**
     
     A regular expression to evaluate an input against.
     
     */
    var pattern: String { get }
}
