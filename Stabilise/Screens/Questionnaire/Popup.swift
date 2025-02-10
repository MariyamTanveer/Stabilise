//
//  QuestionnaireIntroPopup.swift
//  Stabilise
//
//  Created by Mariyam Taveer on 10.02.25.
//

import SwiftUI

struct Popup: View {
    @State private var sliderValue: Double = 2.0 // Default value
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
    
    var body: some View {
        VStack(spacing: 10) {
            // Title
            Text(NSLocalizedString("daily_vadl_assessment", comment: ""))
                .modifier(TextStyles.styledHeadline())

            // Small Date Below the Title
            Text(Date(), style: .date)
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 5)

            // Text Body
            ScrollView {
                Text(attributedIntroText()) // Use attributed text for styling
                    .modifier(TextStyles.styledBody())
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(nil)
            }
            
            VStack(spacing: 15) {
                // Display Rating Text
                Text("\(Int(sliderValue)) - \(ratingDescriptions[Int(sliderValue)] ?? "")")
                    .modifier(TextStyles.styledHeadline(size: 20, isBold: true))
                
                // Slider
                Slider(value: $sliderValue, in: 1...10, step: 1)
                    .accentColor(AppColors.secondary)
                    .frame(height: 40)
                    .padding(.horizontal)
            }
            .padding(.bottom, 10)
            
            // Close Button
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text(NSLocalizedString("Close", comment: "Close Button"))
            }
            .buttonStyle(AppButtonStyle(backgroundColor: AppColors.secondary))
            .padding(.bottom, 10)
        }
        .padding()
    }
}

#Preview {
    Popup()
}
