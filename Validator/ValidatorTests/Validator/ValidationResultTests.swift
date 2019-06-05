import XCTest
@testable import Validator

class ValidationResultTests: XCTestCase {
    
    func test_isValid_valid() {

        let valid: ValidationResult = .valid
        XCTAssertTrue(valid.isValid)
    }
    
    func test_isValid_invalid() {
        
        let invalid = ValidationResult.invalid(["💣"])
        XCTAssertFalse(invalid.isValid)
    }
}
