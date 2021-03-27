//
//  CalculatorButton.swift
//  myCalculator
//
//  Created by Marcel Baláš on 03.02.2021.
//

import SwiftUI

struct CalculatorButton: View {
    
    let label: String
    let imageName: String
    let expression: String
    let action: (_ content: String) -> ()
    
    var foregroundColor : Color {
        if let _ = Int(label) {
            return Color("primaryText")
        } else {
            return Color("accentText")
        }
    }
    
    var body: some View {
        Button(action: { self.action(expression) }, label: {
            ZStack {
                if (!label.isEmpty) {
                    Text(label)
                        .font(.system(size: 37, weight: .medium, design: .monospaced))
                }
                if (!imageName.isEmpty) {
                    Image(systemName: imageName)
                        .font(.system(size: 37))
                }
            }
            .foregroundColor(self.foregroundColor)
        })
        .buttonStyle(PlainButtonStyle())
        .buttonStyle(BorderlessButtonStyle())
    }
}

struct CalculatorButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CalculatorButton(label: "", imageName: "plus.circle", expression: "", action: { _ in })
            CalculatorButton(label: "9", imageName: "", expression: "", action: { _ in })
        }
    }
}
