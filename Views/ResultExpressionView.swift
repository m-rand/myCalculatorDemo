//
//  ResultExpressionView.swift
//  myCalculator
//
//  Created by Marcel Baláš on 04.02.2021.
//

import SwiftUI

struct ResultExpressionView: View {
    
    @EnvironmentObject var calcLogic: CalculatorLogic
    
    var body: some View {
        VStack {
            Spacer()
            ResultView(result: calcLogic.result)
            Spacer()
            ExpressionView(expression: calcLogic.expressionString)
        }
    }
}


struct ResultExpressionView_Previews: PreviewProvider {
    static var previews: some View {
        ResultExpressionView().environmentObject(CalculatorLogic())
    }
}

struct ExpressionView: View {
    
    @Namespace var rightId
    let expression: String
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    Spacer()
                    let a = Array(expression.isEmpty ? "0" : expression)
                    ForEach(a, id: \.self) { c in
                        Text(convertChar(character: c))
                            .font(.system(size: 35, weight: .medium))
                            .foregroundColor(Color("primaryText"))
                    }
                    Text("").id(rightId)
                }
            }
            .onChange(of: expression, perform: { _ in
                proxy.scrollTo(rightId)
            })
        }
    }
    
    func convertChar(character: Character) -> String {
        switch (character) {
        case "*": return String("x")
        default: return String(character)
        }
    }
}

struct ResultView: View {
    
    let result: NSNumber
    
    var body: some View {
        Text(formatResult(number: result))
            .font(.system(size: 70, weight: .medium))
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .truncationMode(.middle)
            .foregroundColor(Color("accentText"))
    }
    
    func formatResult(number: NSNumber) -> String {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.maximumFractionDigits = 9
        return formatter.string(for: number)!
    }
}
