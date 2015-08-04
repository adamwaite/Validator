//
//  ValidatableInterfaceObserver.swift
//  Validator
//
//  Created by Adam Waite on 04/08/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import UIKit

class ValidatableInterfaceObserver: NSObject {
    
    typealias ValidatableInterfaceObserverRuleEvaluation = (rules: Any, change: ValidationResult -> ())
    
    static let instance = ValidatableInterfaceObserver()
    
    private var observations = [String: ValidatableInterfaceObserverRuleEvaluation]()
    
    private func elementIdentifier<E: ValidatableInterfaceElement>(element: E) -> String {
        return "\(unsafeAddressOf(element as! UIView))"
    }
    
    func observeInterfaceElement<E: ValidatableInterfaceElement>(element: E, rules: ValidationRuleSet<E.InputType>, change: ValidationResult -> ()) {
        observations[elementIdentifier(element)] = (rules, change)
    }
    
    func validateInterfaceElement<E: ValidatableInterfaceElement>(element: E) {
        
        guard let ruleEvaluation = observations[elementIdentifier(element)] else {
            return
        }

        let rules: ValidationRuleSet<E.InputType> = ruleEvaluation.rules as! ValidationRuleSet<E.InputType>
        let change: ValidationResult -> () = ruleEvaluation.change
        let result = Validator.validate(input: element.inputValue, rules: rules)
        
        change(result)
    
    }
    
}