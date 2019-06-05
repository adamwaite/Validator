import UIKit

#if os(iOS)
extension UITextView: ValidatableInterfaceElement {
        
    open var inputValue: String? { return text }
    
    open func validateOnInputChange(enabled: Bool) {
        
        switch enabled {        
        case true: NotificationCenter.default.addObserver(self, selector: #selector(performValidation), name: UITextView.textDidChangeNotification, object: self)
        case false: NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: self)
        }
    }
    
    @objc internal func performValidation(_ sender: Notification) {
        
        validate()
    }
}
#endif
