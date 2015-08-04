//
//  StringExampleTableViewCell.swift
//  Validator
//
//  Created by Adam Waite on 04/08/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import UIKit

class StringExampleTableViewCell: ExampleTableViewCell {
    
    @IBOutlet weak var textField: UITextField!
    
    var validationRuleSet: ValidationRuleSet<String>? {
        didSet {
            textField.validateOnChangeWithRules(validationRuleSet!) { result in
                switch result {
                case .Valid:
                    self.stateLabel?.text = "😀"
                case .Invalid(let failureMessages):
                    self.stateLabel?.text = ", ".join(failureMessages)
                }
            }
        }
    }
        
}
