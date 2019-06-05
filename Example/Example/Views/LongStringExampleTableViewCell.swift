import Foundation
import Validator

final class LongStringExampleTableViewCell: ExampleTableViewCell {
    
    @IBOutlet private(set) var textView: UITextView! {
       
        didSet {
            textView.text = nil
        }
    }
    
    var validationRuleSet: ValidationRuleSet<String>? {
        
        didSet {
            textView.validationRules = validationRuleSet
        }
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        textView.validateOnInputChange(enabled: true)
        textView.validationHandler = { result in self.updateValidationState(result: result) }
    }
    
    override func prepareForReuse() {
        
        textView.text = ""
    }
    
}
