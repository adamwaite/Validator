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
    
    var example: String!
    
    override func viewDidLoad() {
        assert(example != nil)
        super.viewDidLoad()
        title = example
        textField.becomeFirstResponder()
    }
    
}