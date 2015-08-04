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
        didSet {
            slider.validateOnChangeWithRules(validationRuleSet!) { result in
                switch result {
                case .Valid:
                    self.stateLabel?.text = "😀"
                case .Invalid(let failureMessages):
                    self.stateLabel?.text = ", ".join(failureMessages)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        slider.addTarget(self, action: "sliderChanged:", forControlEvents: .ValueChanged)
    }
    
    @objc private func sliderChanged(sender: UISlider) {
        sliderValueLabel.text = "\(Int(sender.value))"
    }
    
}

