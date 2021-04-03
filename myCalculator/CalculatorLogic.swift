//
//  CalculatorLogic.swift
//  myCalculator
//
//  Created by Marcel Baláš on 03.02.2021.
//

import Foundation

let USING_NS_EXPRESSION = 0

class CalculatorLogic: ObservableObject {
    @Published var expressionString: String = ""
    @Published var result: NSNumber = NSNumber(0)
    var decimalSeparator: String {
        return NSLocale.current.decimalSeparator ?? ","
    }
    private var decimal = false
}

extension CalculatorLogic {
    static let allowed: [String: String] = [
        ""  : "-(0123456789",
        "0" : ")+-*x/0123456789,.",
        "1" : ")+-*x/0123456789,.",
        "2" : ")+-*x/0123456789,.",
        "3" : ")+-*x/0123456789,.",
        "4" : ")+-*x/0123456789,.",
        "5" : ")+-*x/0123456789,.",
        "6" : ")+-*x/0123456789,.",
        "7" : ")+-*x/0123456789,.",
        "8" : ")+-*x/0123456789,.",
        "9" : ")+-*x/0123456789,.",
        "+" : "0123456789(",
        "-" : "0123456789(",
        "*" : "0123456789(",
        "/" : "123456789(",
        "," : "0123456789",
        "." : "0123456789",
        "(" : "-0123456789",
        ")" : "+-*x/)",
    ]
    
    func apply(what: Character) {
        switch what {
        case "<":
            delete()
            tryEvaluate()
        case "=":
            if (shouldEvaluate()) {
                expressionString = result.stringValue
            }
        default:
            if (isAllowed(what: what)) {
                expressionString.append(_: what)
                if (what.isOperator() && self.decimal) {
                    decimal = false;
                }
                tryEvaluate()
            }
        }
    }
    
    private func delete() {
        if (!expressionString.isEmpty) {
            if (expressionString.last!.isDecimalPoint()) {
                decimal = false;
            }
            expressionString.removeLast();
        }
    }
    
    private func tryEvaluate() {
        if (expressionString == "") {
            result = NSNumber(0)
            return
        }
        if (shouldEvaluate()) {
            evaluate(text: expressionString)
        }
    }

    private func isAllowed(what: Character) -> Bool {
        let exp = expressionString
        let allowed = CalculatorLogic.allowed[exp.isEmpty ? "" : String(exp.last!)] ?? ""
        var result = allowed.contains(what)
        if (result) {
            // special cases:
            switch (what) {
            case ")": // 1. "(" must precede ")"
                result = checkBracketsWhenClosing()
            case decimalSeparator.first!: // 2. don't allow two decimal points on one number
                result = checkDecimal()
            default: break
            }
        }
        return result
    }
    
    private func checkDecimal() -> Bool {
        if (self.decimal) {
            return false
        } else {
            self.decimal = true
            return true
        }
    }
    
    // "(" must precede ")"
    // calling when new closing bracket is to be added
    private func checkBracketsWhenClosing() -> Bool {
        var brackets: Int = 0
        for char in expressionString {
            if char == "(" {
                brackets += 1
            } else if char == ")" {
                brackets -= 1
            }
            if (brackets < 0) {
                return false
            }
        }
        return (brackets > 0)
    }

    
    // don'evaluate if equation is not complete
    private func shouldEvaluate() -> Bool {
        
        // empty string
        if (expressionString == "") {
            return false
        }
        
        // check if it contains only allowed characters
        // e.g. after tap on "=" the result may contain "+inf", "3.12E9" or sth like this
        if (!expressionString.containsOnly(forAnyIn: CalculatorLogic.allowed.keys.joined())) {
            return false
        }
        
        // Ends with operator or decimal point.
        if (expressionString.last!.isOperator() || expressionString.last!.isDecimalPoint()) {
            return false
        }
        
        // count of brackets must equal
        let openCount = expressionString.count(of: "(")
        let closeCount = expressionString.count(of: ")")
        if (openCount != closeCount) {
            return false
        }
        
        return true
    }
    
    private func evaluate(text: String) -> () {
        #if USING_NS_EXPRESSION
        /// Using Apple's NSExpression:
        /// - be aware that the expression HAS TO be in a valid format:
        ///      NSExpression throws an exception, but in the old objc runtime style. Swift cannot handle it.
        /// - NSExpression does not allow "," as a decimal point.
        /// - NSExpression evaluates e.g. "3/2" as an integer. So every d/d expression has to be converted before!
        let myText = fixDivision(text: text.replacingOccurrences(of: ",", with: "."))
        let expression = NSExpression(format: myText)
        result = expression.expressionValue(with: nil, context: nil) as? NSNumber ?? NSNumber(0)
        print("NSExpression: ", expression)
        print("Result: ", result)
        #else
        /// Using Expression:
        /// - written in Swift for Swift
        /// - handles exceptions correctly for swift runtime
        /// - only needs to replace possible "," decimal point to "."
        let expression = Expression(text.replacingOccurrences(of: ",", with: "."))
        do {
            let res = try expression.evaluate()
            result = NSNumber(value: res)
            print("Result: \(res)")
        } catch {
            print("Error: \(error)")
        }
        #endif
    }
    #if USING_NS_EXPRESSION
    private func fixDivision(text: String) -> String {
        let pattern = "\\d+\\/\\d+(?![.])"
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: text.utf16.count)
        _ = regex.matches(in: text, options: [], range: range).map {
            String(text[Range($0.range, in: text)!])
        }
        return regex.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: "$0.0")
    }
    #endif
}

extension Character {
    func isOperator() -> Bool {
        return "+-*/".contains(self)
    }
    func isDecimalPoint() -> Bool {
        return ".,".contains(self)
    }
}

extension String {
    func containsOnly(forAnyIn characters: String) -> Bool {
        let customSet = CharacterSet(charactersIn: characters)
        let inputSet = CharacterSet(charactersIn: self)
        return inputSet.isSubset(of: customSet)
    }
}

extension String {
    func count(of needle: Character) -> Int {
        return reduce(0) {
            $1 == needle ? $0 + 1 : $0
        }
    }
}

