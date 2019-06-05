import XCTest
@testable import Validator

class UISliderValidatorTests: XCTestCase {
    
    func testThatItProvidesAnInputValue() {
        
        let slider = UISlider()
        slider.maximumValue = 10.0
        slider.value = 5.0
        
        XCTAssertTrue(slider.inputValue == Float(5.0))
        
    }
    
    func testThatItCanValidateInputNumbers() {
        
        let slider = UISlider()
        slider.maximumValue = 10.0

        let rule = ValidationRuleComparison<Float>(min: 2.0, max: 7.0, error: testError)

        slider.value = 1.0
        
        let tooSmall = slider.validate(rule: rule)
        XCTAssertFalse(tooSmall.isValid)
        
        slider.value = 8.0
        
        let tooBig = slider.validate(rule: rule)
        XCTAssertFalse(tooBig.isValid)

        slider.value = 4.0
        XCTAssertTrue(slider.inputValue == 4.0)
        
        let valid = slider.validate(rule: rule)
        XCTAssertTrue(valid.isValid)
        
    }
}
