//
//  ListViewController.swift
//  Validator
//
//  Created by Adam Waite on 11/07/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import UIKit

class ExamplesViewController: UIViewController {
    
    // MARK: Interface
    
    @IBOutlet weak var tableView: UITableView!

    // MARK: Examples
    
    // Minimum Length
    let minLengthRules: ValidationRuleSet<String> = {
        var rules = ValidationRuleSet<String>()
        rules.addRule(ValidationRuleLength(min: 5, failureMessage: "Input must be 5 characters or more"))
        return rules
    }()
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
    }
    
}

private struct Examples {
    case LengthMin
    case LengthMax
    case LengthRange
}

extension ExamplesViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}

extension ExamplesViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = "Hi"
        return cell
    }
    
}