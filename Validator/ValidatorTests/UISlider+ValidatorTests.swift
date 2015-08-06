//
//  UISlider+ValidatorTests.swift
//  Validator
//
//  Created by Adam Waite on 06/08/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import Foundation

import XCTest
@testable import Validator

class UISliderFieldValidatorTests: XCTestCase {
    
    func testThatItProvidesAnInputValue() {
        
        let slider = UISlider()
        slider.maximumValue = 10.0
        slider.value = 5.0       
        
        XCTAssertTrue(slider.inputValue == Float(5.0))
        
    }
    
    func testThatItCanValidateInputNumbers() {
        
        let slider = UISlider()
        slider.maximumValue = 10.0

        let rule = ValidationRuleComparison<Float>(min: 2.0, max: 7.0, failureMessage: "💣")

        slider.value = 1.0
        
        let tooSmall = slider.validate(rule: rule)
        XCTAssertFalse(tooSmall.isValid)
        
        slider.value = 8.0
        
        let tooBig = slider.validate(rule: rule)
        XCTAssertFalse(tooBig.isValid)

        slider.value = 4.0
        XCTAssertTrue(slider.inputValue == 4.0)
        
        let valid = slider.validate(rule: rule)
        XCTAssertTrue(valid.isValid)
        
    }
    
    
}