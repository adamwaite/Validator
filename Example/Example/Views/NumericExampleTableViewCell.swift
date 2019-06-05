import UIKit
import Validator

final class NumericExampleTableViewCell: ExampleTableViewCell {
    
    @IBOutlet private(set) var slider: UISlider!
    @IBOutlet private(set) var sliderValueLabel: UILabel!
    
    var validationRuleSet: ValidationRuleSet<Float>? {
        
        didSet {
            slider.validationRules = validationRuleSet
        }
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        slider.validateOnInputChange(enabled: true)
        slider.validationHandler = { result in self.updateValidationState(result: result) }
    }
    
    @IBAction private func sliderChanged(_ sender: UISlider) {
        
        sliderValueLabel.text = "\(Int(sender.value))"
    }
    
}
