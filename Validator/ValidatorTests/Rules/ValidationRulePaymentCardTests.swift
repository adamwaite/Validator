import XCTest
@testable import Validator

class ValidationRulePaymentCardTests: XCTestCase {
    
    private let amexCardNumbers = [
        "371257844149382",
        "375056523214236",
        "379301514519938",
        "370906533950127",
        "378098434720700",
        "378810917610236",
        "372382175840646",
        "343455657382661",
        "372991394493068",
        "379649322793271"
    ]
    
    private let visaCardNumbers = [
        "4539727649815206",
        "4916898870995562",
        "4485209861791419",
        "4542510955720672",
        "4411125045304474",
        "4532731616028154",
        "4024007192471695",
        "4556725954802353",
        "4024007137437934",
        "4556632903577021"
    ]
    
    private let mastercardCardNumbers = [
        "5552654042934989",
        "5133185632192918",
        "5200678765471818",
        "5309805335973748",
        "5401504797361743",
        "5351459742857891",
        "5204001614145077",
        "5272732743621755",
        "5153013089384389",
        "5226169345961163"
    ]
    
    private let maestroCardNumbers = [
        "6759649826438453",
        "6799990100000000019"
    ]
    
    func test_PaymentCardType_initWithCardNumber_invalidCardNumber() {
        
        let none = PaymentCardType(cardNumber: "XXX")
        XCTAssertNil(none)
    }

    func test_PaymentCardType_initWithCardNumber_validCardNumber() {
        
        
        5.times { _ in
           
            let amex = PaymentCardType(cardNumber: self.amexCardNumbers.random)
            XCTAssertEqual(amex, .amex)

            let visa = PaymentCardType(cardNumber: self.visaCardNumbers.random)
            XCTAssertEqual(visa, .visa)
        
            let master = PaymentCardType(cardNumber: self.mastercardCardNumbers.random)
            XCTAssertEqual(master, .mastercard)
            
            let maestro = PaymentCardType(cardNumber: self.maestroCardNumbers.random)
            XCTAssertEqual(maestro, .maestro)
        }
    }
    
    func test_validate_withLuhnCheck_valid() {

        let rule = ValidationRulePaymentCard(error: "💣")

        for validLuhn in ["4716347184862961", "49927398716"] {
            let valid = Validator.validate(input: validLuhn, rule: rule)
            XCTAssertTrue(valid.isValid)
        }
        
        5.times { _ in
            
            let validVisa = Validator.validate(input: self.visaCardNumbers.random, rule: rule)
            XCTAssertTrue(validVisa.isValid)
            
            let validMastercard = Validator.validate(input: self.mastercardCardNumbers.random, rule: rule)
            XCTAssertTrue(validMastercard.isValid)
            
            let validMaestro = Validator.validate(input: self.maestroCardNumbers.random, rule: rule)
            XCTAssertTrue(validMaestro.isValid)
            
            let validAmex = Validator.validate(input: self.amexCardNumbers.random, rule: rule)
            XCTAssertTrue(validAmex.isValid)
        }
    }
    
    func test_validate_acceptedCards_valid() {
        
        let amexOnlyRule = ValidationRulePaymentCard(acceptedTypes: [.amex], error: "💣")
        let visaOrMasterCardRule = ValidationRulePaymentCard(acceptedTypes: [.visa, .mastercard], error: "💣")
        
        let visa = visaCardNumbers.random
        let amex = amexCardNumbers.random
        let mastercard = mastercardCardNumbers.random

        XCTAssertTrue(Validator.validate(input: amex, rule: amexOnlyRule).isValid)
        XCTAssertTrue(Validator.validate(input: visa, rule: visaOrMasterCardRule).isValid)
        XCTAssertTrue(Validator.validate(input: mastercard, rule: visaOrMasterCardRule).isValid)
    }
    
    func test_validate_acceptedCards_invalid() {
        
        let amexOnlyRule = ValidationRulePaymentCard(acceptedTypes: [.amex], error: "💣")
        let visaOrMasterCardRule = ValidationRulePaymentCard(acceptedTypes: [.visa, .mastercard], error: "💣")
        
        let visa = visaCardNumbers.random
        let amex = amexCardNumbers.random
        let mastercard = mastercardCardNumbers.random
        let maestro = maestroCardNumbers.random

        XCTAssertFalse(Validator.validate(input: visa, rule: amexOnlyRule).isValid)
        XCTAssertFalse(Validator.validate(input: mastercard, rule: amexOnlyRule).isValid)
        XCTAssertFalse(Validator.validate(input: maestro, rule: amexOnlyRule).isValid)
        XCTAssertFalse(Validator.validate(input: amex, rule: visaOrMasterCardRule).isValid)
        XCTAssertFalse(Validator.validate(input: maestro, rule: visaOrMasterCardRule).isValid)
    }
}
