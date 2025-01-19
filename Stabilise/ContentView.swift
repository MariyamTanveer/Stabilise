//
//  ContentView.swift
//  Stabilise
//
//  Created by Mariyam Tanveer on 15/11/2024.
//
import SwiftUI

struct ContentView: View {
    @State private var navPath: [String] = []

    var body: some View {
        NavigationStack(path: $navPath) {
            VStack(spacing: 10) { // Use VStack for vertical alignment
                HeaderView(text: "Stabilise")

                Spacer() // Pushes the content below the header down

                // Navigation Link for Questionnaire
                NavigationLink(destination: QuestionnaireIntro()) {
                    Text(NSLocalizedString("Questionnaire", comment: "Questionnaire button"))
                }
                .buttonStyle(AppButtonStyle())

                // Navigation Link for Exercise
                NavigationLink(destination: ExerciseIntro()) {
                    Text(NSLocalizedString("Exercise", comment: "Exercise button"))
                }
                .buttonStyle(AppButtonStyle())
                
                NavigationLink(destination: FallsDiaryIntro()) {
                    Text(NSLocalizedString("Falls_diary", comment: "Falls Diary button"))
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

