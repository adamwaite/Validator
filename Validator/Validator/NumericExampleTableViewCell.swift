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
    
    var validationRuleSet: ValidationRuleSet<Float>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        slider.addTarget(self, action: "valueChanged:", forControlEvents: .ValueChanged)
    }
    
    @objc private func valueChanged(sender: UISlider) {
        guard let rules = validationRuleSet else { return }
        let result = sender.value.validate(rules: rules)
        updateValidationState(result)        
    }

}