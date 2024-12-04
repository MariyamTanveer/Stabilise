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
    @State private var answers: [Int] = Array(repeating: 0, count: 28)
    @State private var sliderValue: Double = 1.0
    @State private var temporaryStorageKey: String = "TemporaryAnswers-\(Date().formatted(date: .numeric, time: .omitted))"
    
    
    let questions: [String] = [
        "Sitting up from lying down",
        "Standing up from sitting on the bed or chair",
        "Dressing the upper body (eg, shirt, brassiere, undershirt",
        "Dressing the lower body (eg, pants, skirt, underpants",
        "Putting on socks or stockings", "Putting on shoes",
        "Moving in or out of the bathtub or shower",
        "Bathing yourself in the bathtub or shower",
        "Reaching overhead (eg, to a cupboard or shelf)",
        "Reaching down (eg, to the floor or shelf)",
        "Meal preparation",
        "Intimate activity (eg, foreplay, sexual activity",
        "Walking on level surfaces",
        "Walking on uneven surfaces",
        "Going up steps", "Going down steps",
        "Walking in narrow spaces (eg, corridor, grocery store aisle)",
        "Walking in open spaces",
        "Walking in crowds",
        "Using an elevator",
        "Using an escalator",
        "Driving a car",
        "Carrying things while walking (eg, package, garbage bag)",
        "Light household chores (eg, dusting, putting items away)",
        "Heavy household chores (eg, vacuuming, moving furniture)",
        "Active recreation (eg, sports, gardening)",
        "Occupational role (eg, job, child care, homemaking, studenet)",
        "Travelling around the community (car, bus)"
    ]
    
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
                        .onChange(of: sliderValue) { oldValue, newValue in
                            if currentQuestionIndex >= 0 && currentQuestionIndex < answers.count {
                                answers[currentQuestionIndex] = Int(newValue)
                            }
                        }
                }
                
                Spacer()
                
                VStack(spacing: 17) {
                    // "Previous" button
                    Button("Previous") {
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
                        Button("Next") {
                            currentQuestionIndex += 1
                            sliderValue = Double(answers[currentQuestionIndex] > 0 ? answers[currentQuestionIndex] : 1)
                        }
                        .buttonStyle(AppButtonStyle())
                    } else {
                        Button("Submit") {
                            saveAnswers()
                            dismiss() // Navigate back to the QuestionnaireIntro
                        }
                        .buttonStyle(AppButtonStyle(backgroundColor: .green))
                    }

                    Button("Save and Return") {
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

}

#Preview {
    NavigationStack {
        Questions()
    }
}
