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

/* 
 
 Thanks to these guys for a lot of this code:
 github.com/vitkuzmenko/CreditCardValidator/blob/master/CreditCardValidator/CreditCardValidator.swift
 gist.github.com/cwagdev/635ce973e8e86da0403a

 */
 
import Foundation

/**
 
 The `PaymentCardType` enum defines several major payment card types, and a 
 means to match a card number against them.
 
 */
public enum PaymentCardType: Int {

    /**
 
     American express card.
     
     */
    case amex

    /**
     
     Mastercard card.
     
     */
    case mastercard
    
    /**
     
     Visa card.
     
     */
    case visa
    
    /**
     
     Maestro card.
     
     */
    case maestro
    
    /**
     
     DinersClub card.
     
     */
    case dinersClub
    
    /**
     
     JCB card.
     
     */
    case jcb
    
    /**
     
     Discover card.
     
     */
    case discover
    
    /**
     
     UnionPay card.
     
     */
    case unionPay

    /**
 
     All payment card types in the enumeration.
     
     */
    public static var all: [PaymentCardType] = [.amex, .mastercard, .visa, .maestro, .dinersClub, .jcb, .discover, .unionPay]
    
    /**
     
     The card type name. `.amex.name == "American Express"`
     
     */
    public var name: String {
        switch self {
        case .amex: return "American Express"
        case .mastercard: return "Mastercard"
        case .visa: return "Visa"
        case .maestro: return "Maestro"
        case .dinersClub: return "Diners Club"
        case .jcb: return "JCB"
        case .discover: return "Discover"
        case .unionPay: return "Union Pay"
        }
    }
    
    /**
     
     A regular expression describing the card number format.
     
     */
    private var identifyingExpression: String {
        switch self {
        case .amex: return "^3[47][0-9]{5,}$"
        case .mastercard: return "^(5[1-5]|2[2-7])[0-9]{5,}$"
        case .visa: return "^4[0-9]{6,}$"
        case .maestro: return "^(?:5[0678]\\d\\d|6304|6390|67\\d\\d)\\d{8,15}$"
        case .dinersClub: return "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
        case .jcb: return "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"
        case .discover: return "^6(?:011|5[0-9]{2})[0-9]{3,}$"
        case .unionPay: return "^62[0-5]\\d{13,16}$"
        }
    }
    
    /**
     
     Returns a `PaymentCardType` if a card type matches the supplied card number,
     or nil if not.
     
     - Parameters:
        - cardNumber: Input to match a card type against
     
     - Returns
     A `PaymentCardType` matching the input, or nil if none match.
    
     */
    private static func typeForCardNumber(_ cardNumber: String?) -> PaymentCardType? {
        guard let cn = cardNumber else { return nil }
        return PaymentCardType.all.first { NSPredicate(format: "SELF MATCHES %@", $0.identifyingExpression).evaluate(with: cn) }
    }
    
    /**
     
     Initializes a card type from a supplied number, or fails if none match.
     
     - Parameters:
        - cardNumber: Input to match a card type against
     
     */
    public init?(cardNumber: String) {
        guard let type = PaymentCardType.typeForCardNumber(cardNumber) else { return nil }
        self.init(rawValue: type.rawValue)
    }
}

/**
 
 `ValidationRulePaymentCard` validates a `String` to see if it's a valid payment 
 card number by firstly running it through the Luhn check algorithm, and 
 secondly ensuring it follows the format of a number of payment card providers
 defined in `PaymentCardType`.
 
 */
public struct ValidationRulePaymentCard: ValidationRule {
    
    public typealias InputType = String

    public let error: Error
    
    /**
 
     A collection of accepted card types to match an input against.
     
     */
    public let acceptedTypes: [PaymentCardType]
    
    /**
     
     Initializes a `ValidationRulePaymentCard` with a collection of accepted 
     card types to match an input against, and an error describing a failed 
     validation.
     
     - Parameters:
        - acceptedTypes: A collection of accepted card types to match an input 
        against.
        - error: An error describing a failed validation.
     
     */
    public init(acceptedTypes: [PaymentCardType], error: Error) {
        self.acceptedTypes = acceptedTypes
        self.error = error
    }
    
    /**
     
     Initializes a `ValidationRulePaymentCard` accepting all `PaymentCardType`s
     with an error describing a failed validation.
     
     - Parameters:
        - error: An error describing a failed validation.
     
     */
    public init(error: Error) {
        self.init(acceptedTypes: PaymentCardType.all, error: error)
    }
    
    /**
     
     Validates the input.
     
     - Parameters:
        - input: Input to validate.
     
     - Returns:
     true if the input satisfies the Luhn Check and matches the availble card
     types.
     
     */
    public func validate(input: String?) -> Bool {
        guard let cardNum = input else { return false }
        guard ValidationRulePaymentCard.luhnCheck(cardNumber: cardNum) else { return false }
        guard let cardType = PaymentCardType(cardNumber: cardNum) else { return false }
        return acceptedTypes.contains(cardType)
    }
    
    private static func luhnCheck(cardNumber: String) -> Bool {
        var sum = 0
        let reversedCharacters = cardNumber.reversed().map { String($0) }
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



