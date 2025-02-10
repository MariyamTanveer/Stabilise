//
//  SettingsView.swift
//  Stabilise
//
//  Created by Mariyam Taveer on 09.02.25.
//


import SwiftUI

struct SettingsView: View {
    @State private var bannerNotification = false
    @State private var questionnaireTime: Date = Date()
    @State private var exerciseTime: Date = Date()
    @State private var automaticActivityDetection = false
    @State private var selectedLanguage = "English" // Default language
    @Environment(\.presentationMode) var presentationMode
    let languages = ["English", "Hungarian"]
    
    var body: some View {
        VStack {
            Text("Settings")
                .modifier(TextStyles.styledHeadline())

            Spacer()
            
            // Settings Options
            VStack(spacing: 16) {
                Toggle(isOn: $bannerNotification) {
                    Text("Banner Notifications")
                }
                .dropDownStyle()
                DatePicker("Questionnaire", selection: $exerciseTime, displayedComponents: .hourAndMinute)
                    .dropDownStyle()
                
                DatePicker("Exercise", selection: $exerciseTime, displayedComponents: .hourAndMinute)
                    .dropDownStyle()
                
                Toggle(isOn: $automaticActivityDetection) {
                    Text("Automatic Activity Detection")
                }
                .dropDownStyle()
            }
            .padding(.horizontal)
            
            // Language Selection
            VStack(alignment: .leading) {
                Text("Language")
                    .modifier(TextStyles.styledHeadline())
                HStack {
                    ForEach(languages, id: \.self) { language in
                        Button(action: {
                            selectedLanguage = language
                        }) {
                            Text(language)
                                .font(.system(size: 22))
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)
                                .background(selectedLanguage == language ? Color(AppColors.primary) : Color.clear)
                                .foregroundColor(selectedLanguage == language ? .white : .black)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                        }
                    }
                }
            }
            .padding()
            
            Spacer()
            
            // Buttons
            VStack {
                Button("Save") {
                }
                .buttonStyle(AppButtonStyle(backgroundColor: AppColors.primary))                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()  // Dismiss to go back
                }) {
                    Text(NSLocalizedString("Back", comment: "Back Button"))
                }
                .buttonStyle(AppButtonStyle(backgroundColor: AppColors.secondary))
                
            }
            .padding(.bottom, 1)
            .padding()
        }
    }
}

#Preview {
    SettingsView()
}
