//
//  QuestionnaireIntro.swift
//  Stabilise
//
//  Created by Mariyam Tanveer on 17/11/2024.
//

import SwiftUI

struct PortalIntro: View {
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var showErrorMessage: Bool = false
    @State private var navigateToPortalDetails: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @State private var actualPassword: String = "Stabilise2025"

    var body: some View {
        VStack(spacing: 10) {
            Text(NSLocalizedString("Clinician's Portal", comment: ""))
                .modifier(TextStyles.styledHeadline())

            Image(systemName: "person")
                .foregroundColor(AppColors.secondary)
                .font(.system(size: 250))

            Spacer()

            // Password Field
            VStack(alignment: .leading, spacing: 10) {
                Text("Password")
                    .modifier(TextStyles.styledHeadline())

                HStack {
                    if isPasswordVisible {
                        TextField("Enter Password", text: $password)
                    } else {
                        SecureField("Enter Password", text: $password)
                    }

                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                            .foregroundColor(.gray)
                    }
                }
                .dropDownStyle()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(showErrorMessage ? Color.red : Color.clear, lineWidth: 2)
                )
            }
            .padding()

            if showErrorMessage {
                Text("Password is incorrect")
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.top, -10)
            }

            Spacer()

            VStack {
                Button(NSLocalizedString("Log in", comment: "")) {
                    if password == actualPassword {
                        navigateToPortalDetails = true
                    } else {
                        showErrorMessage = true
                    }
                }
                .buttonStyle(AppButtonStyle())

                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text(NSLocalizedString("Back", comment: "Back Button"))
                }
                .buttonStyle(AppButtonStyle(backgroundColor: AppColors.secondary))
            }
            .padding(.bottom, 1)

            // Navigation to PortalDetails
            NavigationLink(
                destination: PortalDetails(),
                isActive: $navigateToPortalDetails
            ) {
                EmptyView()
            }
        }
        .padding()
    }
}

#Preview {
    PortalIntro()
}
