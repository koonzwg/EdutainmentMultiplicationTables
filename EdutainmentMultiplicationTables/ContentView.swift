//
//  ContentView.swift
//  EdutainmentMultiplicationTables
//
//  Created by William Koonz on 3/18/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isGameActive = false
    @State private var multiplicationTable = 2
    @State private var numberOfQuestions = 5
    
    var body: some View {
        Group {
            if isGameActive {
                GameView(multiplicationTable: multiplicationTable, numberOfQuestions: numberOfQuestions)
            } else {
                SettingsView(multiplicationTable: $multiplicationTable, numberOfQuestions: $numberOfQuestions, startGame: startGame)
            }
        }
    }
    
    func startGame() {
        isGameActive = true
    }
}

struct SettingsView: View {
    @Binding var multiplicationTable: Int
    @Binding var numberOfQuestions: Int
    var startGame: () -> Void
    
    var body: some View {
        VStack {
            Text("Settings")
                .font(.largeTitle)
            
            Stepper(value: $multiplicationTable, in: 2...12, step: 1) {
                Text("Multiplication Table: \(multiplicationTable)")
            }
            
            Picker("Number of Questions", selection: $numberOfQuestions) {
                Text("5").tag(5)
                Text("10").tag(10)
                Text("20").tag(20)
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Button("Start Game") {
                startGame()
            }
        }
    }
}

struct Question {
    var text: String
    var answer: Int
}

struct GameView: View {
    var multiplicationTable: Int
    var numberOfQuestions: Int
    
    @State private var questions: [Question] = []
    @State private var currentQuestionIndex = 0
    @State private var userAnswer = ""
    @State private var score = 0
    @State private var isGameOver = false
    @State private var isLoading = true
    
    var body: some View {
        VStack {
            if isGameOver {
                Text("Game Over")
                    .font(.largeTitle)
                
                Text("Your score: \(score) out of \(numberOfQuestions)")
                
                Button("Play Again") {
                    resetGame()
                }
            } else if isLoading {
                Text("Generating questions...")
                    .font(.title)
            } else {
                Text(questions[currentQuestionIndex].text)
                    .font(.title)
                
                TextField("Enter your answer", text: $userAnswer)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                
                Button("Submit") {
                    checkAnswer()
                }
            }
        }
        .onAppear(perform: generateQuestions)
    }
    
    func generateQuestions() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            for _ in 1...numberOfQuestions {
                let num1 = Int.random(in: 1...multiplicationTable)
                let num2 = Int.random(in: 1...12)
                let question = Question(text: "\(num1) x \(num2) = ?", answer: num1 * num2)
                questions.append(question)
            }
            isLoading = false
        }
    }
    
    func checkAnswer() {
        let answer = Int(userAnswer) ?? 0
        if answer == questions[currentQuestionIndex].answer {
            score += 1
        }
        
        currentQuestionIndex += 1
        userAnswer = ""
        
        if currentQuestionIndex == numberOfQuestions {
            isGameOver = true
        }
    }
    
    func resetGame() {
        questions = []
        currentQuestionIndex = 0
        userAnswer = ""
        score = 0
        isGameOver = false
        isLoading = true // Set isLoading to true when resetting the game
        generateQuestions()
    }
}


#Preview {
    ContentView()
}
