//
//  CalculatorLogic.swift
//  myCalculator
//
//  Created by Marcel Baláš on 03.02.2021.
//

import Foundation


class CalculatorLogic: ObservableObject {
    @Published var expressionString: String = ""
    @Published var result: String = "0"
    var decimalSeparator: String {
        return NSLocale.current.decimalSeparator ?? ","
    }
}

extension CalculatorLogic {
    func addExpression(exp: Character) {
        // code follows here
    }
}


