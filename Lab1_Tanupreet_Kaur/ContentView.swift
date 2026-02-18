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
    
    //Layout
    var body: some View {
        ZStack{
            //Background
            LinearGradient(
                colors: [Color(.systemIndigo).opacity(0.9)], startPoint: .topLeading, endPoint: .bottomTrailing
            ).ignoresSafeArea()
            
            VStack(spacing:18){
                header
                NumberCard
            }
            

        }
    }
    
    // UI Parts
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6){
                Text("Prime Number Game")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                
                Text("Decide before the timer runs out!")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.85))
            }
            
            //Timer
            HStack{
                Image(systemName: "timer")
                Text("\(secondsLeft)s")
                    .monospacedDigit()
                    .font(.system(size: 16, weight: .bold, design: .rounded))
            }
            .foregroundStyle(.white)
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(.white.opacity(0.16))
            .clipShape(Capsule())
        }
    }
    
    private var NumberCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.15), radius: 18, x: 0, y: 10)
            
            VStack(spacing: 14){
                Text("\(currentNumber)")
                    .font(.system(size: 70, weight: .heavy, design: .rounded))
                    .foregroundStyle(.primary)
                
                Text("Prime or Not Prime?")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundStyle(.secondary)
                
                // Result area
                Group {
                    if let ok = resultCorrect {
                        Image(systemName: ok ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .font(.system(size: 54, weight: .bold))
                            .foregroundStyle(ok ? .green : .red)
                            .transition(.scale.combined(with: .opacity))
                    } else {
                        // Placeholder to keep layout stable
                        Image(systemName: "circle")
                            .font(.system(size: 54, weight: .bold))
                            .foregroundStyle(.clear)
                    }
                }
                .animation(.spring(response: 0.35, dampingFraction: 0.7), value: resultCorrect)
                
            }
            .padding(22)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 340)
    }
}

#Preview {
    ContentView()
}
