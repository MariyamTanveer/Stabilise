//
//  QuestionnaireIntro.swift
//  Stabilise
//
//  Created by Mariyam Tanveer on 17/11/2024.
//

import SwiftUI

struct ExerciseIntro: View {
    @State private var sliderValue: Double = 2.0 // Default value
    @State private var isResumeAvailable: Bool = false // Tracks if resume is available
    @State private var temporaryStorageKey: String = "" // Dynamically set temporary key
    
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
    
    // Function to create attributed text with bold numbers
    private func attributedIntroText() -> AttributedString {
        var attributedString = AttributedString(
            NSLocalizedString("exercise_intro_text", comment: "")
        )
        
        // Bold each number (1, 2, 3, ..., 5)
        for number in 1...5 {
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
        let todayKey = "ExerciseDraft-\(Date().formatted(date: .numeric, time: .omitted))"
        temporaryStorageKey = todayKey // Set the temporary key
        
        // Check if the key exists in UserDefaults
        if UserDefaults.standard.object(forKey: todayKey) != nil {
            isResumeAvailable = true
        }
    }

    var body: some View {
            VStack(spacing: 10) {
                
                Text(NSLocalizedString("exercise_heading", comment: ""))
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
                    // Calculate index for description based on slider value
                    let descriptionIndex = min(Int(sliderValue / 20) + 1, 5) // Divides 0-100 into 5 intervals (0-20, 20-40, etc.)
                    let description = ratingDescriptions[descriptionIndex] ?? ""

                    // Display Rating Text with percentage and description
                    Text("\(Int(sliderValue))% - \(description)")
                        .modifier(TextStyles.styledHeadline(size: 20, isBold: true))
                    
                    // Slider
                    Slider(value: $sliderValue, in: 0...100) // Continuous percentage slider
                        .accentColor(AppColors.secondary) // Change slider color
                        .frame(height: 40) // Adjust slider height
                        .padding(.horizontal)
                }
                .padding(.bottom, 10)
                
                VStack {
                    NavigationLink(destination: ExerciseQuestions()) {
                        Text(isResumeAvailable ? NSLocalizedString("Resume", comment: "Resume") : NSLocalizedString("next", comment: "Next"))
                    }
                    .buttonStyle(AppButtonStyle())
                                        
                    NavigationLink(destination: ContentView()) {
                        Text(NSLocalizedString("back", comment: "Back Button"))
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
    ExerciseIntro()
}
