/*

 ValidationRulePaymentCard.swift
 Validator

 Created by @adamwaite.

 Copyright (c) 2015 Adam Waite. All rights reserved.

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.

*/

// Thanks to these guys for a lot of this code:
// github.com/vitkuzmenko/CreditCardValidator/blob/master/CreditCardValidator/CreditCardValidator.swift
// gist.github.com/cwagdev/635ce973e8e86da0403a

import Foundation

public enum PaymentCardType: Int {

    case Amex, Mastercard, Visa, Maestro, DinersClub, JCB, Discover, UnionPay

    public static var all: [PaymentCardType] = [.Amex, .Mastercard, .Visa, .Maestro, .DinersClub, .JCB, .Discover, .UnionPay]
    
    public var name: String {
        switch self {
        case .Amex: return "American Express"
        case .Mastercard: return "Mastercard"
        case .Visa: return "Visa"
        case .Maestro: return "Maestro"
        case .DinersClub: return "Diners Club"
        case .JCB: return "JCB"
        case .Discover: return "Discover"
        case .UnionPay: return "Union Pay"
        }
    }
    
    private var identifyingExpression: String {
        switch self {
        case .Amex: return "^3[47][0-9]{5,}$"
        case .Mastercard: return "^5[1-5][0-9]{5,}$"
        case .Visa: return "^4[0-9]{6,}$"
        case .Maestro: return "^(?:5[0678]\\d\\d|6304|6390|67\\d\\d)\\d{8,15}$"
        case .DinersClub: return "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
        case .JCB: return "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"
        case .Discover: return "^6(?:011|5[0-9]{2})[0-9]{3,}$"
        case .UnionPay: return "^62[0-5]\\d{13,16}$"
        }
    }
    
    private static func typeForCardNumber(string: String?) -> PaymentCardType? {
        guard let string = string else { return nil }
        for type in PaymentCardType.all {
            let predicate = NSPredicate(format: "SELF MATCHES %@", type.identifyingExpression)
            if predicate.evaluate(with: string) {
                return type
            }
        }
        return nil
    }
    
    public init?(cardNumber: String) {
        guard let type = PaymentCardType.typeForCardNumber(string: cardNumber) else { return nil }
        self.init(rawValue: type.rawValue)
    }
}

public struct ValidationRulePaymentCard: ValidationRule {
    
    public typealias InputType = String
    
    public let acceptedTypes: [PaymentCardType]
    public let failureError: ValidationErrorType
    
    public init(acceptedTypes: [PaymentCardType], failureError: ValidationErrorType) {
        self.acceptedTypes = acceptedTypes
        self.failureError = failureError
    }
    
    public init(failureError: ValidationErrorType) {
        self.init(acceptedTypes: PaymentCardType.all, failureError: failureError)
    }
    
    public func validateInput(input: String?) -> Bool {
        guard let cardNum = input else { return false }
        guard ValidationRulePaymentCard.luhnCheck(cardNumber: cardNum) else { return false }
        guard let cardType = PaymentCardType(cardNumber: cardNum) else { return false }
        return acceptedTypes.contains(cardType)
    }
    
    private static func luhnCheck(cardNumber: String) -> Bool {
        var sum = 0
        let reversedCharacters = cardNumber.characters.reversed().map { String($0) }
        for (idx, element) in reversedCharacters.enumerated() {
            guard let digit = Int(element) else { return false }
            switch ((idx % 2 == 1), digit) {
            case (true, 9): sum += 9
            case (true, 0...8): sum += (digit * 2) % 9
            default: sum += digit
            }
        }
        return sum % 10 == 0
    }
}



