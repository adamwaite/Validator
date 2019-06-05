import UIKit
import Validator

final class StringExampleTableViewCell: ExampleTableViewCell {
    
    @IBOutlet private(set) var textField: UITextField!
    
    var validationRuleSet: ValidationRuleSet<String>? {
        
        didSet {
            
            textField.validationRules = validationRuleSet
        }
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        textField.validateOnInputChange(enabled: true)
        textField.validationHandler = { result in self.updateValidationState(result: result) }
    }
    
    override func prepareForReuse() {
        
        textField.text = ""
    }
    
}
