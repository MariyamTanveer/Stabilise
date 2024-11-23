//
//  QuestionnaireIntro.swift
//  Stabilise
//
//  Created by Mariyam Tanveer on 17/11/2024.
//

import SwiftUI

struct QuestionnaireIntro: View {
    @State private var sliderValue: Double = 2.0 // Default value
    
    // Rating Descriptions
    private let ratingDescriptions = [
        1: "Independent",
        2: "Uncomfortable",
        3: "Decreased ability",
        4: "Slower, Cautious",
        5: "Prefer using an object for help",
        6: "Must use an object for help",
        7: "Must use special equipment",
        8: "Need physical assistance",
        9: "Dependent",
        10: "Too difficult, no longer perform"
    ]

    var body: some View {
        VStack(spacing: 20) {
            
            Text("Daily VADL Assessment")
                .modifier(TextStyles.styledHeadline())
            
            // Text Body
            Text("""
            Please rate your performance of today’s activities on a scale of 1 to 10:

            1 = Independent  
            2 = Uncomfortable  
            3 = Decreased ability  
            4 = Slower, Cautious  
            5 = Prefer using an object for help  
            6 = Must use an object for help  
            7 = Must use special equipment  
            8 = Need physical assistance  
            9 = Dependent  
            10 = Too difficult, no longer perform  

            Select NA if you didn’t perform the activity today.
            """)
            .modifier(TextStyles.styledBody())
            .padding()

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
            
            Button(NSLocalizedString("Next", comment: "Next")) {
                print("Next button pressed")
            }
            .buttonStyle(AppButtonStyle())
            
        }
        .padding()
    }
}

#Preview {
    QuestionnaireIntro()
}
