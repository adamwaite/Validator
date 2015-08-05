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
    
    var validationRuleSet: ValidationRuleSet<String>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.addTarget(self, action: "editingChanged:", forControlEvents: .EditingChanged)
        
    }
    
    @objc private func editingChanged(sender: UITextField) {
        guard let rules = validationRuleSet else { return }
        guard let input = sender.text else { return }
        let result = input.validate(rules: rules)
        updateValidationState(result)
    }
    
}
