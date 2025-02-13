//
//  SettingsView.swift
//  Stabilise
//
//  Created by Mariyam Taveer on 09.02.25.
//


import SwiftUI

struct SettingsView: View {
    @StateObject private var languageManager = LanguageManager()
    @State private var bannerNotification = UserDefaults.standard.bool(forKey: "bannerNotification")
        @State private var questionnaireTime: Date = (UserDefaults.standard.object(forKey: "questionnaireTime") as? Date) ?? Date()
        @State private var exerciseTime: Date = (UserDefaults.standard.object(forKey: "exerciseTime") as? Date) ?? Date()
    @State private var automaticActivityDetection = false
    @State private var showAlert = false
    @State private var showLanguageAlert = false
    @State private var selectedLanguage: String?
    @Environment(\.presentationMode) var presentationMode
    let languages = ["en": "English", "hu": "Hungarian"]
    
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
                .onChange(of: bannerNotification) {
                    UserDefaults.standard.set(bannerNotification, forKey: "bannerNotification")
                    if bannerNotification {
                        NotificationManager.shared.requestPermission()
                    }
                }
                .dropDownStyle()
                
                DatePicker("Questionnaire", selection: $questionnaireTime, displayedComponents: .hourAndMinute)
                    .onChange(of: questionnaireTime) {
                        UserDefaults.standard.set(questionnaireTime, forKey: "questionnaireTime")
                    }
                    .dropDownStyle()
                
                DatePicker("Exercise", selection: $exerciseTime, displayedComponents: .hourAndMinute)
                    .onChange(of: exerciseTime) {
                        UserDefaults.standard.set(exerciseTime, forKey: "exerciseTime")
                    }
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
                    ForEach(languages.keys.sorted(), id: \.self) { langCode in
                        Button(action: {
                            selectedLanguage = langCode
                            showLanguageAlert = true
                        }) {
                            Text(languages[langCode]!)
                                .font(.system(size: 22))
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)
                                .background(languageManager.selectedLanguage == langCode ? Color(AppColors.primary) : Color.clear)
                                .foregroundColor(languageManager.selectedLanguage == langCode ? .white : .black)
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
                    NotificationManager.shared.scheduleNotifications()
                    showAlert = true
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
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Settings Saved"), message: Text("Your preferences have been updated."), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $showLanguageAlert) {
            Alert(
                title: Text("Language Changed"),
                message: Text("Please restart the application for changes to take effect."),
                dismissButton: .default(Text("OK"), action: {
                    if let lang = selectedLanguage {
                        languageManager.selectedLanguage = lang
                        presentationMode.wrappedValue.dismiss()
                    }
                })
            )
        }
    }
}

#Preview {
    SettingsView()
}
