//
//  Questions.swift
//  Stabilise
//
//  Created by Mariyam Taveer on 24.11.24.
//

import SwiftUI

struct ExerciseQuestions: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentQuestionIndex = 0
    @State private var answers: [Int] = Array(repeating: -1, count: 2)
    @State private var sliderValue: Double = 1.0
    @State private var temporaryStorageKey: String = "ExerciseDraft-\(Date().formatted(date: .numeric, time: .omitted))"
    @State private var showPopup = false
    @State private var naSelected = false
    
    
    private var questions: [String] {
        [
            NSLocalizedString("exercise_eyes_open", comment: ""),
            NSLocalizedString("exercise_eyes_close", comment: ""),
        ]
    }
    
    // Rating Descriptions
    private var ratingDescriptions: [Int: String] {
        [
            1: NSLocalizedString("couldnt_do", comment: ""),
            2: NSLocalizedString("almost_fell", comment: ""),
            3: NSLocalizedString("significant_difficulty", comment: ""),
            4: NSLocalizedString("slight_difficulty", comment: ""),
            5: NSLocalizedString("without_problems", comment: ""),
        ]
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                // Question Counter
                Text("Question \(currentQuestionIndex + 1) of \(questions.count)")
                    .font(.headline)
                
                // Current Question
                Text(questions[currentQuestionIndex])
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .frame(height: 150)
                
                Spacer()
                
                VStack(spacing: 15) {
                    // Calculate index for description based on slider value
                    let descriptionIndex = min(Int(sliderValue / 20) + 1, 5) // Divides 0-100 into 5 intervals (0-20, 20-40, etc.)
                    let description = ratingDescriptions[descriptionIndex] ?? ""

                    // Display Rating Text with percentage and description
                    Text("\(Int(sliderValue))% - \(description)")
                        .modifier(TextStyles.styledHeadline(size: 20, isBold: true))
                        .frame( width: 320, height: 60)
                    
                    // Slider (Now Disabled when NA is Selected)
                    Slider(value: $sliderValue, in: 0...100)
                        .accentColor(AppColors.secondary)
                        .frame(height: 40)
                        .padding(.horizontal)
                        .disabled(naSelected) // Disable if NA is selected
                }
                
                Spacer()
                
                VStack(spacing: 17) {
                    
                    HStack {
                        // NA Button Action
                        Button(action: {
                            naSelected.toggle()
                            if naSelected {
                                answers[currentQuestionIndex] = -1  // Keep -1 when NA is selected
                            } else {
                                answers[currentQuestionIndex] = max(1, Int(sliderValue)) // Restore previous value
                            }
                        }) {
                            Image(systemName: naSelected ? "checkmark.square.fill" : "square")
                                .resizable()
                                .foregroundColor(AppColors.primary)
                                .frame(width: 30, height: 30)
                        }
                        Text("NA - Not Applicable")
                            .modifier(TextStyles.styledHeadline())
                            .padding(.leading, 5)
                        
                        Spacer()
                        
                        Button(action: {
                            showPopup = true
                        }) {
                            Image(systemName: "questionmark.circle.fill")
                                .resizable()
                                .foregroundColor(.green)
                                .frame(width: 40, height: 40)
                        }
                        .sheet(isPresented: $showPopup) {
                            ExercisePopup()
                        }
                        .padding(.trailing, 10)
                    }
                    .padding(.bottom, 10)
                        
                    // "Previous" button
                    Button(NSLocalizedString("Previous", comment: "")) {
                        if currentQuestionIndex > 0 {
                            saveAnswer()
                            currentQuestionIndex -= 1
                            loadAnswer()
                        }
                    }
                    .buttonStyle(AppButtonStyle())
                    .opacity(currentQuestionIndex > 0 ? 1 : 0)
                    .disabled(currentQuestionIndex == 0)
                    .frame(height: 44)
                    
                    if currentQuestionIndex < questions.count - 1 {
                        Button(NSLocalizedString("next", comment: "Next")) {
                            saveAnswer()
                            currentQuestionIndex += 1
                            loadAnswer()
                        }
                        .buttonStyle(AppButtonStyle())
                    } else {
                        Button(NSLocalizedString("Submit", comment: "")) {
                            saveAnswer()
                            submitResponses()
                            printUserDefaultsData()
                            dismiss() // Navigate back to the ExerciseIntro
                        }
                        .buttonStyle(AppButtonStyle(backgroundColor: .green))
                    }

                    Button(NSLocalizedString("Save and Return", comment: "")) {
                        saveAnswer()
                        saveDraft()
                        printUserDefaultsData()
                        dismiss() // Navigate back to the ExerciseIntro
                    }
                    .buttonStyle(AppButtonStyle(backgroundColor: AppColors.secondary))
                    .frame(height: 44)
                }
            }
            .padding()
            .onAppear {
                loadDraft()
                if sliderValue == 0 {
                    sliderValue = 1.0
                }
            }
        }
    }
    
    private func saveAnswer() {
        if naSelected {
            answers[currentQuestionIndex] = -1
        } else {
            answers[currentQuestionIndex] = Int(sliderValue)
        }
    }

    private func loadAnswer() {
        let savedValue = answers[currentQuestionIndex]
        if savedValue == -1 {
            naSelected = true
        } else {
            naSelected = false
            sliderValue = Double(savedValue)
        }
    }

    private func saveDraft() {
        let draftData: [String: Any] = [
            "answers": answers,
            "currentQuestionIndex": currentQuestionIndex
        ]
        UserDefaults.standard.set(draftData, forKey: temporaryStorageKey)
    }

    private func loadDraft() {
        if let savedDraft = UserDefaults.standard.dictionary(forKey: temporaryStorageKey),
           let savedAnswers = savedDraft["answers"] as? [Int],
           let savedQuestionIndex = savedDraft["currentQuestionIndex"] as? Int,
           savedAnswers.count == answers.count {
            
            answers = savedAnswers
            currentQuestionIndex = savedQuestionIndex
            sliderValue = Double(answers[currentQuestionIndex])
        }
    }

    private func submitResponses() {
        let finalKey = "Exercise-\(Date().formatted(date: .numeric, time: .omitted))"
        UserDefaults.standard.set(answers, forKey: finalKey)
        UserDefaults.standard.removeObject(forKey: temporaryStorageKey)
    }
    
    private func printUserDefaultsData() {
        let keys = UserDefaults.standard.dictionaryRepresentation().keys.filter { $0.hasPrefix("Exercise-") }
        for key in keys {
            if let data = UserDefaults.standard.array(forKey: key) as? [Int] {
                print("\(key): \(data)")
            }
        }
        if let temporaryAnswers = UserDefaults.standard.array(forKey: temporaryStorageKey) as? [Int] {
            print("\(temporaryStorageKey): \(temporaryAnswers)")
        }
    }
    

}

#Preview {
    NavigationStack {
        ExerciseQuestions()
    }
}
