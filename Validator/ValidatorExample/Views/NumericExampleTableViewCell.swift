//
//  NumericExampleTableViewCell.swift
//  Validator
//
//  Created by Adam Waite on 04/08/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import UIKit

class NumericExampleTableViewCell: ExampleTableViewCell {
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderValueLabel: UILabel!
    
    var validationRuleSet: ValidationRuleSet<Float>? {
        didSet { slider.validationRules = validationRuleSet }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        slider.validateOnInputChange(true)
        slider.validationHandler = { result in self.updateValidationState(result) }
    }
    
}