//
//  ListViewController.swift
//  Validator
//
//  Created by Adam Waite on 11/07/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Examples
    
    let stringExamples: [ValidatorExample<String>] = {
        
        var stringExamples = [ValidatorExample<String>]()
        
        // Minimum Length
        var minLengthRules = ValidationRuleSet<String>()
        minLengthRules.addRule(ValidationRuleLength(min: 5, failureMessage: "Input must be 5 or more characters"))
        let minLengthExample = ValidatorExample(
            name: "Minimum Length",
            summary: "Validates the input is 5 characters or more",
            rules: minLengthRules)
        stringExamples.append(minLengthExample)
        
        return stringExamples
        
        }()
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        switch segue.destinationViewController {
        case let destination as DetailViewController:
            let selected = tableView.indexPathForSelectedRow
            let example = stringExamples[selected!.row]
            destination.example = example
        default:
            break
        }
    }
    
}

extension ListViewController: UITableViewDelegate {

    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
    
extension ListViewController: UITableViewDataSource {
    
    // MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stringExamples.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let example = stringExamples[indexPath.row]
        cell.textLabel?.text = example.name
        cell.detailTextLabel?.text = example.summary
        return cell
    }
    
}