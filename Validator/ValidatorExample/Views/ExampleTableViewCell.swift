//
//  ExampleTableViewCell.swift
//  Validator
//
//  Created by Adam Waite on 04/08/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import UIKit

class ExampleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stateLabel.text = "😐"
    }
        
    func updateValidationState(result: ValidationResult) {
        switch result {
        case .Valid: stateLabel.text = "😀"
        case .Invalid(let failureMessages): stateLabel.text = ", ".join(failureMessages)
        }
    }
    
}