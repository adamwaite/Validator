import UIKit

#if os(iOS)
extension UISlider: ValidatableInterfaceElement {
        
    open var inputValue: Float? { return value }
    
    open func validateOnInputChange(enabled: Bool) {
        
        switch enabled {
        
        case true:
            addTarget(self, action: #selector(performValidation), for: .valueChanged)
        
        case false:
            removeTarget(self, action: #selector(performValidation), for: .valueChanged)
        
        }
    }
    
    @objc private func performValidation(_ sender: UISlider) {
        sender.validate()
    }
    
}
#endif
