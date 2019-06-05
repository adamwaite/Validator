import XCTest
@testable import Validator

#if os(iOS)
private final class TextField: UITextField {
    
}

class UITextFieldValidatorTests: XCTestCase {
    
    func test_inputValue() {
        
        let textField = UITextField()
        textField.text = "Hello"
        XCTAssertTrue(textField.inputValue == "Hello")
    }

    func test_validate() {
        
        let textField = UITextField()
        textField.text = "Hello"
        
        let noRulesValidation = textField.validate()
        XCTAssertTrue(noRulesValidation.isValid)
        
        let rule = ValidationRuleCondition<String>(error: "💣") { ($0?.contains("A"))! }
        
        let invalid = textField.validate(rule: rule)
        XCTAssertFalse(invalid.isValid)
        
        textField.text = "Hello Adam"
        
        let valid = textField.validate(rule: rule)
        XCTAssertTrue(valid.isValid)
    }
    
    func test_validateOnInputChange() {
       
        var textField = UITextField()
        
        var rules = ValidationRuleSet<String>()
        let rule = ValidationRuleCondition<String>(error: "💣") { ($0?.contains("A"))! }
        rules.add(rule: rule)
        
        var didRegisterInvalid = false
        var didRegisterValid = false
        
        textField.validationRules = rules
        XCTAssertNotNil(textField.validationRules)
        
        textField.validateOnInputChange(enabled: true)
        let actions = textField.actions(forTarget: textField, forControlEvent: .editingChanged) ?? []
        XCTAssertFalse(actions.isEmpty)

        textField.validationHandler = { result in
            switch result {
            case .valid: didRegisterValid = true
            case .invalid(_): didRegisterInvalid = true
            }
        }
        
        textField.text = "BCDE"
        let _ = textField.validate() // textField.sendActionsForControlEvents(.EditingChanged) doesn't seem to work in test env
        XCTAssert(didRegisterInvalid)
        XCTAssertFalse(didRegisterValid)
        
        textField.text = "ABCDE"
        let _ = textField.validate()
        XCTAssert(didRegisterInvalid)
        XCTAssert(didRegisterValid)
    }
}
#endif
