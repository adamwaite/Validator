import Foundation

public enum PaymentCardType: Int, CaseIterable {

    case amex
    case mastercard
    case visa
    case maestro
    case dinersClub
    case jcb
    case discover
    case unionPay
    
    private var expression: String {
        
        switch self {
        
        case .amex:
            return "^3[47][0-9]{5,}$"
        
        case .mastercard:
            return "^(5[1-5]|2[2-7])[0-9]{5,}$"
        
        case .visa:
            return "^4[0-9]{6,}$"
        
        case .maestro:
            return "^(?:5[0678]\\d\\d|6304|6390|67\\d\\d)\\d{8,15}$"
        
        case .dinersClub:
            return "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
        
        case .jcb:
            return "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"
        
        case .discover:
            return "^6(?:011|5[0-9]{2})[0-9]{3,}$"
        
        case .unionPay:
            return "^62[0-5]\\d{13,16}$"
        
        }
    }
    
    private static func type(cardNumber: String?) -> PaymentCardType? {

        guard let cardNumber = cardNumber else {
            
            return nil
        }
        
        return PaymentCardType.allCases.first {
            
            NSPredicate(format: "SELF MATCHES %@", $0.expression).evaluate(with: cardNumber)
        }
    }
    
    public init?(cardNumber: String) {
    
        guard let type = PaymentCardType.type(cardNumber: cardNumber) else {
            
            return nil
        }
        
        self.init(rawValue: type.rawValue)
    }
}

public struct ValidationRulePaymentCard: ValidationRule {
    
    public let acceptedTypes: [PaymentCardType]
    public let error: ValidationError
    
    public init(acceptedTypes: [PaymentCardType], error: ValidationError) {
        
        self.acceptedTypes = acceptedTypes
        self.error = error
    }
    
    public init(error: ValidationError) {
    
        self.init(acceptedTypes: PaymentCardType.allCases, error: error)
    }

    public func validate(input: String?) -> Bool {
        
        guard let cardNumber = input else {
            
            return false
        }
        
        guard luhnCheck(cardNumber: cardNumber) else {
            
            return false
        }
        
        guard let cardType = PaymentCardType(cardNumber: cardNumber) else {
            
            return false
        }
        
        return acceptedTypes.contains(cardType)
    }
    
    private func luhnCheck(cardNumber: String) -> Bool {
        
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
