//
//  CalculatorView.swift
//  myCalculator
//
//  Created by Marcel Baláš on 02.02.2021.
//

import SwiftUI

struct CalculatorView: View {
    
    @EnvironmentObject var calcLogic: CalculatorLogic
   
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    func onButtonTap(exp: String) -> () {
        calcLogic.addExpression(exp: exp.first!)
    }
    
    var body: some View {
        LazyVGrid(columns: columns, alignment: .center, spacing: 35) {
            ForEach(0..<buttons.count, id: \.self) { idx in
                CalculatorButton(
                    label: buttons[idx].label,
                    imageName: buttons[idx].imageName,
                    expression: buttons[idx].expression,
                    action: onButtonTap)
            }
        }
    }
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView().environmentObject(CalculatorLogic())
    }
}

extension CalculatorView {
    var buttons: [(label: String, imageName: String, expression: String)] {
        return [
            ("", "delete.left", "<"),
            ("(", "", "("),
            (")", "", ")"),
            ("", "plus.circle", "+"),
            ("1", "", "1"),
            ("2", "", "2"),
            ("3", "", "3"),
            ("", "minus.circle", "-"),
            ("4", "", "4"),
            ("5", "", "5"),
            ("6", "", "6"),
            ("", "multiply.circle", "x"),
            ("7", "", "7"),
            ("8", "", "8"),
            ("9", "", "9"),
            ("", "divide.circle", "/"),
            ("", "plus.slash.minus", "n"),
            ("0", "", "0"),
            (calcLogic.decimalSeparator, "", calcLogic.decimalSeparator),
            ("", "equal.circle", "=")
        ]
    }
}
