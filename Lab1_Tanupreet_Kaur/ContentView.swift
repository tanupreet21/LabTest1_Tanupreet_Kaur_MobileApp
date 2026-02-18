//
//  ContentView.swift
//  Lab1_Tanupreet_Kaur
//
//  Created by Tanupreet Kaur on 2026-02-17.
//

import SwiftUI
internal import Combine

struct ContentView: View {
    
    private let roundSeconds: Int = 5
    private let numberRange: ClosedRange<Int> = 2...200
    
    // Game State variables
    @State private var currentNumber: Int = Int.random(in: 2...200)
    @State private var secondsLeft: Int = 5
    
    @State private var hasAnswered: Bool = false
    // nil = no results yet, true = correct, false = wrong
    @State private var resultCorrect: Bool? = nil
    
    @State private var attempts: Int = 0
    @State private var correct: Int = 0
    @State private var wrong: Int = 0
    
    @State private var showStatsAlert: Bool = false
    
    //Timer
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    

    var body: some View {
    }
}

#Preview {
    ContentView()
}
