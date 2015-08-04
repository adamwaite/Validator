//
//  StringExampleTableViewCell.swift
//  Validator
//
//  Created by Adam Waite on 04/08/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import UIKit

class StringExampleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var stateLabel: UILabel!
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stateLabel.text = "😐"
    }
    
    override func prepareForReuse() {
        stateLabel.text = "😐"
    }
    
}
