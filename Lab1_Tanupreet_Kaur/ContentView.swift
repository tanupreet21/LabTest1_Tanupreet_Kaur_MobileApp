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
                
                //Progress bar
                progressBar.padding(.horizontal, 8)
            }
            .padding(22)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 340)
    }
    
    private var progressBar: some View {
        let progress = Double(secondsLeft)/Double(roundSeconds)
        
        return VStack(spacing: 8){
            GeometryReader { geo in
                ZStack(alignment: .leading){
                    Capsule()
                        .fill(Color.secondary.opacity(0.15))
                    Capsule()
                        .fill(secondsLeft <= 2 ? Color.red.opacity(0.85) : Color.blue.opacity(0.75))
                        .frame(width: geo.size.width * progress)
                        .animation(.linear(duration: 0.15), value: secondsLeft)
                }
            }.frame(height: 10)
            
            Text(hasAnswered ? "Locked until next number.." : "Tap an answer")
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(.secondary)
            
        }
    }
    
    private var choiceRow: some View {
        HStack(spacing: 14){
            choiceButton(title: "Prime", systemImage: "sparkles", tint: .green{
                answer(userSaysPrime: true)
            }
                         
                         action: choiceButton(title: "Not Prime", systemImage: "slash.circle", tint: .orange{
                answer(userSaysPrime: false)
            }
                         
        }
    }
    
    private func choiceButton(title: String, systemImage: String, tint: Color, action: @escaping () -> Void) -> some View{
        Button(action: action){
            HStack{
                Image(systemName: systemImage)
                Text(title)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(tint.opacity(hasAnswered ? 0.45 : 0.9))
            )
            .shadow(color: .black.opacity(0.12), radius: 12, x:0, y:8)
        }
        .disabled(hasAnswered) //disable after one tap
    }
    
    private func answer(userSaysPrime: Bool){
        guard !hasAnswered else {return}
        hasAnswered = true
        
        let actualPrime = isPrime(currentNumber)
        let isCorrect = (userSaysPrime == actualPrime)
        record(isCorrect: isCorrect)
    }
    
    private func record(isCorrect: Bool){
        resultCorrect = isCorrect
        
        attempts += 1
        if isCorrect {
            correct += 1
        } else {
            wrong += 1
        }
        
        // Show dialog after every 10 attempts
        if attempts % 10 == 0 {
            showStatsAlert = true
        }
    }
    
    private func isPrime(_ n: Int) -> Bool {
        if n < 2 {return false}
        if n == 2 {return true}
        if n % 2 == 0 { return false}
        var i = 3
        while i * i <= n {
            if n % i == 0 {return false}
            i += 2
        }
        return true
    }
    
    private func startNewRound(){
        currentNumber = Int.random(in: numberRange)
        secondsLeft = roundSeconds
        hasAnswered = false
        resultCorrect = nil
    }
    
    private func statPill(title: String, value: String) -> some View {
        VStack(spacing: 4){
            Text(title)
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(.white.opacity(0.85))
            Text(value)
                .font(.system(size: 18, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
        .background(.white.opacity(0.16))
        .clipShape(RoundedRectangle(cornerRadius: 16, style:.continuous))
    }
    
    private var footer: some View {
        HStack {
            statPill(title: "Attempts", value: "\(attempts)")
            Spacer()
            statPill(title: "Correct", value: "\(correct)")
            Spacer()
            statPill(title: "Wrong", value: "\(wrong)")
        }
        .padding(.top, 6)
    }
}

#Preview {
    ContentView()
}
