//
//  PortalDetails.swift
//  Stabilise
//
//  Created by Mariyam Taveer on 03.02.25.
//

import SwiftUI

struct PortalDetails: View {
    @State private var patientID: String = UserDefaults.standard.string(forKey: "patientID") ?? ""
    @State private var isEditing: Bool = UserDefaults.standard.string(forKey: "patientID") == nil
    @Environment(\.presentationMode) var presentationMode  // For dismissing the view

    var body: some View {
        VStack(spacing: 10) {
            
            Text(NSLocalizedString("Clinician's Portal", comment: ""))
                .modifier(TextStyles.styledHeadline())
            
            Spacer()

            // Patient ID Field
            VStack(alignment: .leading, spacing: 10) {
                Text("Patient ID")
                    .modifier(TextStyles.styledHeadline())

                TextField("Enter Patient ID", text: $patientID)
                    .disabled(!isEditing)
                    .dropDownStyle()
            }
            .padding()
            
            Button(isEditing ? NSLocalizedString("Set", comment: "") : NSLocalizedString("Edit", comment: "")) {
                if isEditing {
                    UserDefaults.standard.set(patientID, forKey: "patientID")
                    if let storedPatientID = UserDefaults.standard.string(forKey: "patientID") {
                        print("Stored Patient ID: \(storedPatientID)")
                    }
                }
                isEditing.toggle()
            }
            .buttonStyle(AppButtonStyle())

            Spacer()
            
            VStack {
                Button(NSLocalizedString("Settings", comment: "")) {
                    print("Settings button pressed")
                }
                .buttonStyle(AppButtonStyle())

                NavigationLink(destination: ExportData()) {
                        Text(NSLocalizedString("Export Data", comment: ""))
                }
                .buttonStyle(AppButtonStyle())

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
    }
}

#Preview {
    PortalDetails()
}
