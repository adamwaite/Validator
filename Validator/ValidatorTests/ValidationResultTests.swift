import XCTest
@testable import Validator

class ValidationResultTests: XCTestCase {
    
    func testThatAValidResultIsDeemedValid() {
        let valid = ValidationResult.valid
        XCTAssertTrue(valid.isValid)
       
        let err = testError
        
        let invalid = ValidationResult.invalid([err])
        XCTAssertFalse(invalid.isValid)
    }
}
