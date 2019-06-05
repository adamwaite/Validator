import UIKit
import Validator

final class ExamplesViewController: UITableViewController {
   
    override func viewDidLoad() {
     
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100.0
    }
}

extension ExamplesViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0: return "String (with UITextField)"
        case 1: return "Numeric (with UISlider)"
        case 2: return "String (with UITextView)"
        default: return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0: return 7
        case 1: return 1
        case 2: return 1
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        
        switch indexPath.section {
        
        case 0:
        
            let stringCell = tableView.dequeueReusableCell(withIdentifier: "StringExample", for: indexPath) as! StringExampleTableViewCell
            stringCell.validationRuleSet = ValidationRuleSet<String>()
            cell = stringCell
            
            switch indexPath.row {

            case 0:
                stringCell.titleLabel.text = "Minimum Length"
                stringCell.summaryLabel.text = "Ensures the input is at least 5 characters long using ValidationRuleLength"
                let minLengthRule = ValidationRuleLength(min: 5, error: ExampleValidationError("😫"))
                stringCell.validationRuleSet?.add(rule: minLengthRule)
            
            case 1:
                stringCell.titleLabel.text = "Maximum Length"
                stringCell.summaryLabel.text = "Ensures the input is at most 5 characters long using ValidationRuleLength"
                let maxLengthRule = ValidationRuleLength(max: 5, error: ExampleValidationError("😫"))
                stringCell.validationRuleSet?.add(rule: maxLengthRule)
                
            case 2:
                stringCell.titleLabel.text = "Range Length"
                stringCell.summaryLabel.text = "Ensures the input is between 5 and 20 characters long using ValidationRuleLength"
                let rangeLengthRule = ValidationRuleLength(min: 5, max: 20, error: ExampleValidationError("😫"))
                stringCell.validationRuleSet?.add(rule: rangeLengthRule)
                
            case 3:
                stringCell.titleLabel.text = "Email Address"
                stringCell.summaryLabel.text = "Ensures the input is a valid email address using ValidationRulePattern"
                let emailPattern = EmailValidationPattern.simple
                let emailRule = ValidationRulePattern(pattern: emailPattern, error: ExampleValidationError("😫"))
                stringCell.validationRuleSet?.add(rule: emailRule)
            
            case 4:
                stringCell.titleLabel.text = "Contains"
                stringCell.summaryLabel.text = "Ensures the input is one of the greetings 'hello', 'hey' or 'hi' using ValidationRuleContains"
                let containsRule = ValidationRuleContains<String, Array<String>>(sequence: ["hello", "hey", "hi"], error: ExampleValidationError("😫"))
                stringCell.validationRuleSet?.add(rule: containsRule)

            case 5:
                stringCell.titleLabel.text = "Dynamic Equality"
                stringCell.summaryLabel.text = "Ensures the input is equal to a dynamic value (in this case just 'Password') using ValidationRuleEquality"
                let equalityRule = ValidationRuleEquality<String>(dynamicTarget: { return "Password" }, error: ExampleValidationError("😫"))
                stringCell.validationRuleSet?.add(rule: equalityRule)

            case 6:
                stringCell.titleLabel.text = "Multiple Rules"
                stringCell.summaryLabel.text = "Combines multiple validations into one rule set - range length, contains a digit and contains a capital letter"
                let rangeLengthRule = ValidationRuleLength(min: 5, max: 30, error: ExampleValidationError("😫"))
                let digitPattern = ContainsNumberValidationPattern()
                let digitRule = ValidationRulePattern(pattern: digitPattern, error: ExampleValidationError("😥"))
                let casePattern = CaseValidationPattern.uppercase
                let capitalRule = ValidationRulePattern(pattern: casePattern, error: ExampleValidationError("😞"))
                stringCell.validationRuleSet?.add(rule: rangeLengthRule)
                stringCell.validationRuleSet?.add(rule: digitRule)
                stringCell.validationRuleSet?.add(rule: capitalRule)
                
            default:
                break
            }
            
        case 1:
            
            let numericCell = tableView.dequeueReusableCell(withIdentifier: "NumericExample", for: indexPath) as! NumericExampleTableViewCell
            numericCell.validationRuleSet = ValidationRuleSet<Float>()
            cell = numericCell
            
            switch indexPath.row {
                
            case 0:
                numericCell.titleLabel.text = "Comparison"
                numericCell.summaryLabel.text = "Ensures the input is between 2 and 7 using ValidationRuleComparison"
                let comparisonRule = ValidationRuleComparison<Float>(min: 5, max: 7, error: ExampleValidationError("😫"))
                numericCell.validationRuleSet?.add(rule: comparisonRule)

            case 1:
                numericCell.titleLabel.text = "Equality"
                numericCell.summaryLabel.text = "Ensures the input is equal to 5.0 using ValidationRuleEquality"
                let comparisonRule = ValidationRuleEquality<Float>(target: 5.0, error: ExampleValidationError("😫"))
                numericCell.validationRuleSet?.add(rule: comparisonRule)
                
            default:
                break
            }
            
        case 2:
            
            let longStringCell = tableView.dequeueReusableCell(withIdentifier: "LongStringExample", for: indexPath) as! LongStringExampleTableViewCell
            longStringCell.validationRuleSet = ValidationRuleSet<String>()
            cell = longStringCell
            
            switch indexPath.row {
                
            case 0:
                longStringCell.titleLabel.text = "Condition"
                longStringCell.summaryLabel.text = "Ensures the input contains the word 'Hello' using ValidationRuleCondition"
                let comparisonRule = ValidationRuleCondition<String>(error: ExampleValidationError("😫")) { $0?.contains("Hello") ?? false }
                longStringCell.validationRuleSet?.add(rule: comparisonRule)
                
            default:
                break
            }

            
        default:
            break
        }
        
        return cell!
        
    }
    
}
