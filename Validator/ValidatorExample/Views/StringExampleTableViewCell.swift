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
        didSet { textField.validationRules = validationRuleSet }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.validateOnInputChange(true)
        textField.validationHandler = { result in self.updateValidationState(result) }
    }
    
}
