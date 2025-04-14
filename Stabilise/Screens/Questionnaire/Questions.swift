//
//  Questions.swift
//  Stabilise
//
//  Created by Mariyam Taveer on 24.11.24.
//

import SwiftUI

struct Questions: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentQuestionIndex = 0
    @State private var answers: [Int] = Array(repeating: 1, count: 28)
    @State private var sliderValue: Double = 1.0
    @State private var showPopup = false
    @State private var temporaryStorageKey: String = "TemporaryAnswers-\(Date().formatted(date: .numeric, time: .omitted))"
    @State private var naSelected: Bool = false
    
    
    private var questions: [String] {
        [
            NSLocalizedString("question_sitting_up", comment: ""),
            NSLocalizedString("question_standing_up", comment: ""),
            NSLocalizedString("question_dressing_upper", comment: ""),
            NSLocalizedString("question_dressing_lower", comment: ""),
            NSLocalizedString("question_putting_on_socks", comment: ""),
            NSLocalizedString("question_putting_on_shoes", comment: ""),
            NSLocalizedString("question_moving_bathtub", comment: ""),
            NSLocalizedString("question_bathing", comment: ""),
            NSLocalizedString("question_reaching_overhead", comment: ""),
            NSLocalizedString("question_reaching_down", comment: ""),
            NSLocalizedString("question_meal_preparation", comment: ""),
            NSLocalizedString("question_intimate_activity", comment: ""),
            NSLocalizedString("question_walking_level", comment: ""),
            NSLocalizedString("question_walking_uneven", comment: ""),
            NSLocalizedString("question_going_up_steps", comment: ""),
            NSLocalizedString("question_going_down_steps", comment: ""),
            NSLocalizedString("question_walking_narrow", comment: ""),
            NSLocalizedString("question_walking_open", comment: ""),
            NSLocalizedString("question_walking_crowds", comment: ""),
            NSLocalizedString("question_using_elevator", comment: ""),
            NSLocalizedString("question_using_escalator", comment: ""),
            NSLocalizedString("question_driving", comment: ""),
            NSLocalizedString("question_carrying_things", comment: ""),
            NSLocalizedString("question_light_chores", comment: ""),
            NSLocalizedString("question_heavy_chores", comment: ""),
            NSLocalizedString("question_active_recreation", comment: ""),
            NSLocalizedString("question_occupational_role", comment: ""),
            NSLocalizedString("question_travelling", comment: "")
        ]
    }
    
    private var ratingDescriptions: [Int: String] {
        [
            1: NSLocalizedString("rating_independent", comment: ""),
            2: NSLocalizedString("rating_uncomfortable", comment: ""),
            3: NSLocalizedString("rating_decreased_ability", comment: ""),
            4: NSLocalizedString("rating_slower_cautious", comment: ""),
            5: NSLocalizedString("rating_prefer_object", comment: ""),
            6: NSLocalizedString("rating_must_object", comment: ""),
            7: NSLocalizedString("rating_special_equipment", comment: ""),
            8: NSLocalizedString("rating_physical_assistance", comment: ""),
            9: NSLocalizedString("rating_dependent", comment: ""),
            10: NSLocalizedString("rating_too_difficult", comment: "")
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
                    .frame(height: 80)
                
                Spacer()
                
                VStack(spacing: 15) {
                    // Display Rating Text
                    Text("\(Int(sliderValue)) - \(ratingDescriptions[Int(sliderValue)] ?? "")")
                        .font(.system(size: 20, weight: .bold))
                    
                    // Slider
                    Slider(value: $sliderValue, in: 1...10, step: 1)
                        .disabled(naSelected) // Disable slider when NA is selected
                        .onChange(of: sliderValue) { oldValue, newValue in
                            if !naSelected {  // Only update if NA is NOT selected
                                answers[currentQuestionIndex] = max(1, Int(newValue))
                            }
                        }
                }
                
                Spacer()
                                
                VStack(spacing: 17) {
                    
                    // All Time Checkbox
                    HStack {
                        Button(action: {
                            naSelected.toggle()
                            if naSelected {
                                answers[currentQuestionIndex] = 0  // Store 0 when NA is selected
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
                            Popup()
                        }
                        .padding(.trailing, 10)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading) // Align to left
                    .padding(.leading, 10)
                    .padding(.bottom, 10)
                    
                    // "Previous" button
                    Button(NSLocalizedString("Previous", comment: "")) {
                        if currentQuestionIndex > 0 {
                            currentQuestionIndex -= 1
                            sliderValue = Double(answers[currentQuestionIndex] > 0 ? answers[currentQuestionIndex] : 1)
                        }
                    }
                    .buttonStyle(AppButtonStyle())
                    .opacity(currentQuestionIndex > 0 ? 1 : 0)
                    .disabled(currentQuestionIndex == 0)
                    .frame(height: 44)
                    
                    if currentQuestionIndex < questions.count - 1 {
                        Button(NSLocalizedString("next", comment: "Next")) {
                            currentQuestionIndex += 1
                            sliderValue = Double(answers[currentQuestionIndex] > 0 ? answers[currentQuestionIndex] : 1)
                        }
                        .buttonStyle(AppButtonStyle())
                    } else {
                        Button(NSLocalizedString("Submit", comment: "")) {
                            saveAnswers()
                            dismiss() // Navigate back to the QuestionnaireIntro
                        }
                        .buttonStyle(AppButtonStyle(backgroundColor: .green))
                    }

                    Button(NSLocalizedString("Save and Return", comment: "")) {
                        saveTemporaryAnswers()
                        dismiss() // Navigate back to the QuestionnaireIntro
                    }
                    .buttonStyle(AppButtonStyle(backgroundColor: AppColors.secondary))
                    .frame(height: 44)
                }
            }
            .padding()
            .onAppear {
                removeOldSavedAnswers()
                loadTemporaryAnswers()
                if sliderValue == 0 {
                    sliderValue = 1.0
                }
            }
        }
    }
    
    private func saveAnswers() {
        let currentDate = Date().formatted(date: .numeric, time: .omitted)
        let uniqueKey = "SubmittedAnswer-\(currentDate)"
        let savedEntry: [String: Any] = [
            "date": Date(),
            "responses": answers
        ]
        removeTemporaryEntry() // Ensure no temporary entries remain
        // Save the entry with a unique key
        saveToLocalStorage(savedEntry, key: uniqueKey)
        printUserDefaultsData()
    }
    
    private func saveTemporaryAnswers() {
        let temporaryEntry: [String: Any] = [
            "date": Date(),
            "responses": answers,
            "currentQuestionIndex": currentQuestionIndex
        ]
        removeOldTemporaryEntries() // Remove older temporary entries if the date changes
        saveToLocalStorage(temporaryEntry, key: temporaryStorageKey)
        printUserDefaultsData()
    }
    
    private func loadTemporaryAnswers() {
        if let temporaryEntry = fetchFromLocalStorage(key: temporaryStorageKey) as? [String: Any],
           let savedAnswers = temporaryEntry["responses"] as? [Int],
           let savedIndex = temporaryEntry["currentQuestionIndex"] as? Int {
            answers = savedAnswers
            currentQuestionIndex = savedIndex
            sliderValue = Double(answers[currentQuestionIndex] > 0 ? answers[currentQuestionIndex] : 1)
        } else {
            sliderValue = 1.0
        }
    }
    
    private func removeTemporaryEntry() {
        UserDefaults.standard.removeObject(forKey: temporaryStorageKey)
    }
    
    private func removeOldTemporaryEntries() {
        let keys = UserDefaults.standard.dictionaryRepresentation().keys
        for key in keys where key.hasPrefix("TemporaryAnswers-") && key != temporaryStorageKey {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
    
    private func saveToLocalStorage(_ data: [String: Any], key: String) {
        UserDefaults.standard.set(data, forKey: key)
    }
    
    private func fetchFromLocalStorage(key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
    
    private func removeOldSavedAnswers() {
        UserDefaults.standard.removeObject(forKey: "savedAnswers")
    }
    
    private func printUserDefaultsData() {
        let keys = UserDefaults.standard.dictionaryRepresentation().keys.filter { $0.hasPrefix("SubmittedAnswer-") }
        for key in keys {
            if let data = UserDefaults.standard.dictionary(forKey: key) {
                print("\(key): \(data)")
            }
        }
        if let temporaryAnswers = UserDefaults.standard.dictionary(forKey: temporaryStorageKey) {
            print("\(temporaryStorageKey): \(temporaryAnswers)")
        }
    }
    
    private func clearAllLocalStorage() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        
        for key in dictionary.keys {
            defaults.removeObject(forKey: key)
        }
        
        print("All UserDefaults data cleared.")
    }

}

#Preview {
    NavigationStack {
        Questions()
    }
}
