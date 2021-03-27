//
//  myCalculatorDemoApp.swift
//  Shared
//
//  Created by Marcel Baláš on 26.03.2021.
//

import SwiftUI

@main
struct myCalculatorDemoApp: App {
    @StateObject private var calcLogic = CalculatorLogic()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(calcLogic)
        }
    }
}
