//
//  DetailViewController.swift
//  Validator
//
//  Created by Adam Waite on 11/07/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var validationStateLabel: UILabel!
    
    var example: ValidatorExample<String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = example.name
        
        summaryLabel.text = example.summary
        
        textField.validateOnChangeWithRules(example.rules) { result in
            
            switch result {
            case .Valid:
                self.validationStateLabel.text = "😁"
            case .Invalid(let failureMessages):
                self.validationStateLabel.text = failureMessages.first
            }
            
        }
        
        
        textField.becomeFirstResponder()
        
    }
    
}