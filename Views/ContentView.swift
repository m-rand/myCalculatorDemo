//
//  ContentView.swift
//  Shared
//
//  Created by Marcel Baláš on 26.03.2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            ResultView()
            Divider()
                .background(Color("secondaryText"))
            CalculatorView()
                .padding(.top)
                .padding(.bottom, 50)
        }
        .padding(.horizontal)
        .background(Color("primaryBackground").edgesIgnoringSafeArea(.all))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(CalculatorLogic())
    }
}
