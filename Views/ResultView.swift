//
//  ResultView.swift
//  myCalculator
//
//  Created by Marcel Baláš on 04.02.2021.
//

import SwiftUI

struct ResultView: View {
    
    @EnvironmentObject var calcLogic: CalculatorLogic
    
    var body: some View {
        VStack {
            Spacer()
            Text(calcLogic.result)
                .font(.system(size: 70, weight: .medium))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .truncationMode(.middle)
                .foregroundColor(Color("accentText"))
            Spacer()
            Text(calcLogic.expressionString == "" ? "0" : calcLogic.expressionString)
                .font(.system(size: 35, weight: .medium))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .truncationMode(.head)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .foregroundColor(Color("primaryText"))
        }
    }
}


struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView().environmentObject(CalculatorLogic())
    }
}
