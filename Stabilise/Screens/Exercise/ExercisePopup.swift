//
//  ExerciseIntro 2.swift
//  Stabilise
//
//  Created by Mariyam Taveer on 10.02.25.
//
import SwiftUI

struct ExercisePopup: View {
    @State private var sliderValue: Double = 2.0 // Default value
    @State private var isResumeAvailable: Bool = false // Tracks if resume is available
    @State private var temporaryStorageKey: String = "" // Dynamically set temporary key
    @Environment(\.presentationMode) var presentationMode  // For dismissing the view

    
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
        
        let boldStrings = ["0%", "25%", "50%", "75%", "100%"]
        for number in boldStrings {
            if let range = attributedString.range(of: "\(number) =") {
                attributedString[range].font = .boldSystemFont(ofSize: 18) // Bold the number and '='
            }
        }
        
        if let naRange = attributedString.range(of: "NA") {
                attributedString[naRange].font = .boldSystemFont(ofSize: 18) // Bold "NA"
        }
        
        return attributedString
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
                    // Back button
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text(NSLocalizedString("Close", comment: ""))
                    }
                    .buttonStyle(AppButtonStyle(backgroundColor: AppColors.secondary))
                }
                .padding(.bottom, 1)
            }
            .padding()
        }
    }

#Preview {
    ExercisePopup()
}
