//
//  TestHelpers.swift
//  Validator
//
//  Created by Adam Waite on 09/12/2015.
//  Copyright © 2015 adamjwaite.co.uk. All rights reserved.
//

import Foundation
@testable import Validator

let testError = ValidationError(message: "💣")

extension Array {
    var random: Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}

extension Int {
    func times(_ closure: (Int) -> ()) {
        for i in 0..<self {
            closure(i)
        }
    }
}
