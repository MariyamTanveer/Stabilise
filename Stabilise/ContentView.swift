//
//  ContentView.swift
//  Stabilise
//
//  Created by Mariyam Tanveer on 15/11/2024.
//
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 10) { // Use VStack for vertical alignment
                HeaderView(text: "Stabilise")

                Spacer() // Pushes the content below the header down

                // Navigation Link for Questionnaire
                NavigationLink(destination: QuestionnaireIntro()) {
                    Text(NSLocalizedString("Questionnaire", comment: "Questionnaire button"))
                }
                .buttonStyle(AppButtonStyle())

                // Other buttons remain as is
                Button(NSLocalizedString("Exercise", comment: "Exercise button")) {
                    print("Exercise button pressed")
                }
                .buttonStyle(AppButtonStyle())

                Button(NSLocalizedString("Falls_diary", comment: "Falls Diary button")) {
                    print("Falls Diary button pressed")
                }
                .buttonStyle(AppButtonStyle())

                Button(NSLocalizedString("Clinicians_portal", comment: "Clinician's button")) {
                    print("Clinician's button pressed")
                }
                .buttonStyle(AppButtonStyle())

                Spacer() // Pushes content down to center buttons
            }
            .padding() // Add padding around the VStack
        }
    }
}

#Preview {
    ContentView()
}

