//
//  QuestionnaireIntro.swift
//  Stabilise
//
//  Created by Mariyam Tanveer on 17/11/2024.
//

import SwiftUI

struct QuestionnaireIntro: View {
    @State private var sliderValue: Double = 2.0 // Default value
    @State private var isResumeAvailable: Bool = false // Tracks if resume is available
    @State private var temporaryStorageKey: String = "" // Dynamically set temporary key
    @State private var showAlert: Bool = false
    @State private var isShowingNextDestination: Bool = false
    @Environment(\.presentationMode) var presentationMode  // For dismissing the view
    
    // Rating Descriptions
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
    
    // Function to create attributed text with bold numbers
    private func attributedIntroText() -> AttributedString {
        var attributedString = AttributedString(
            NSLocalizedString("questionnaire_intro_text", comment: "")
        )
        
        // Bold each number (1, 2, 3, ..., 10)
        for number in 1...10 {
            if let range = attributedString.range(of: "\(number) =") {
                attributedString[range].font = .boldSystemFont(ofSize: 18) // Bold the number and '='
            }
        }
        
        if let naRange = attributedString.range(of: "NA") {
                attributedString[naRange].font = .boldSystemFont(ofSize: 18) // Bold "NA"
        }
        
        return attributedString
    }
    
    // Check for temporary answers in local storage
    private func checkForTemporaryAnswers() {
        isResumeAvailable = false
        // Get today's date as a formatted string
        let todayKey = "TemporaryAnswers-\(Date().formatted(date: .numeric, time: .omitted))"
        temporaryStorageKey = todayKey // Set the temporary key
        
        // Check if the key exists in UserDefaults
        if UserDefaults.standard.object(forKey: todayKey) != nil {
            isResumeAvailable = true
        }
    }
    
    private func checkIfSubmittedToday() -> Bool {
        let date = Date().formatted(date: .numeric, time: .omitted)
        let todayKey = "SubmittedAnswer-\(date)"
        return UserDefaults.standard.object(forKey: todayKey) != nil
    }
    
    private func handleNextButton() {
        if checkIfSubmittedToday() {
            showAlert = true
        } else {
            isShowingNextDestination = true
        }
    }

    var body: some View {
            VStack(spacing: 10) {
                
                Text(NSLocalizedString("daily_vadl_assessment", comment: ""))
                    .modifier(TextStyles.styledHeadline())
                
                // Small Date Below the Title
                Text(Date(), style: .date) // Display today's date in a localized format
                    .font(.subheadline) // Smaller font size
                    .foregroundColor(.gray) // Subtle color for date
                    .padding(.bottom, 5) // Add spacing below the date
                
                // Text Body
                ScrollView {
                    Text(attributedIntroText()) // Use attributed text for styling
                        .modifier(TextStyles.styledBody())
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading) // Ensure the text uses full width
                        .lineLimit(nil) // Allow unlimited lines
                }
                
                VStack(spacing: 15) {
                    // Display Rating Text
                    Text("\(Int(sliderValue)) - \(ratingDescriptions[Int(sliderValue)] ?? "")")
                        .modifier(TextStyles.styledHeadline(size: 20, isBold: true))
                    
                    // Slider
                    Slider(value: $sliderValue, in: 1...10, step: 1)
                        .accentColor(AppColors.secondary) // Change slider color
                        .frame(height: 40) // Adjust slider height
                        .padding(.horizontal)
                }
                .padding(.bottom, 10)
                
                VStack {
                    Button(action: handleNextButton) {
                        Text(isResumeAvailable ? NSLocalizedString("Resume", comment: "Resume") : NSLocalizedString("next", comment: "Next"))
                    }
                    .buttonStyle(AppButtonStyle())
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Already Submitted"),
                            message: Text("A questionnaire has already been submitted today."),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                    .navigationDestination(isPresented: $isShowingNextDestination) {
                        Questions()
                    }
                                        
                    // Back button
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text(NSLocalizedString("Back", comment: "Back Button"))
                    }
                    .buttonStyle(AppButtonStyle(backgroundColor: AppColors.secondary))
                }
                .padding(.bottom, 1)
            }
            .padding()
            .onAppear {
                checkForTemporaryAnswers()
            }
        }
    }

#Preview {
    QuestionnaireIntro()
}
