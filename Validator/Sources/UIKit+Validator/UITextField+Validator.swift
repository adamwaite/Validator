import UIKit

#if os(iOS)
extension UITextField: ValidatableInterfaceElement {
    
    public typealias InputType = String
    
    open var inputValue: String? { return text }
    
    open func validateOnInputChange(enabled: Bool) {
        switch enabled {
        case true: addTarget(self, action: #selector(performValidation), for: .editingChanged)
        case false: removeTarget(self, action: #selector(performValidation), for: .editingChanged)
        }
    }
    
    open func validateOnEditingEnd(enabled: Bool) {
        switch enabled {
        case true: addTarget(self, action: #selector(performValidation), for: .editingDidEnd)
        case false: removeTarget(self, action: #selector(performValidation), for: .editingDidEnd)
        }
    }
    
    @objc internal func performValidation(sender: UITextField) {
        
        sender.validate()
    }
    
}
#endif
