//
//  ExportData.swift
//  Stabilise
//
//  Created by Mariyam Taveer on 05.02.25.
//
import SwiftUI

struct ExportData: View {
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var allTimeSelected: Bool = true
    @Environment(\.presentationMode) var presentationMode  // For dismissing the view
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Export Data")
                .modifier(TextStyles.styledHeadline())
            
            Spacer()
            
            VStack(spacing: 15) {
                DatePicker("Start Date", selection: $startDate, in: ...Date(), displayedComponents: .date)
                    .dropDownStyle()
                DatePicker("End Date", selection: $endDate, in: ...startDate, displayedComponents: .date)
                    .dropDownStyle()
            }
            .padding(.bottom, 20)
            
            // All Time Checkbox
            HStack {
                Button(action: {
                    allTimeSelected.toggle()
                }) {
                    Image(systemName: allTimeSelected ? "checkmark.square.fill" : "square")
                        .resizable() // Allows resizing
                        .foregroundColor(AppColors.primary)
                        .frame(width: 30, height: 30)
                }
                
                Text("All Time")
                    .modifier(TextStyles.styledHeadline())
                    .padding(.leading, 5)
            }
            .frame(maxWidth: .infinity, alignment: .leading) // Align to left
            .padding(.leading, 10)
            
            Spacer()
            
            VStack {
                Button(NSLocalizedString("Export All Data", comment: "")) {
                    print("All button pressed")
                }
                .buttonStyle(AppButtonStyle())
                Button(NSLocalizedString("Export Falls Diary", comment: "")) {
                    print("Falls button pressed")
                }
                .buttonStyle(AppButtonStyle())
                Button(NSLocalizedString("Export Questionnaire", comment: "")) {
                    print("Questionnaire button pressed")
                }
                .buttonStyle(AppButtonStyle())
                Button(NSLocalizedString("Export Exercises", comment: "")) {
                    print("Questionnaire button pressed")
                }
                .buttonStyle(AppButtonStyle())
                Button(action: {
                    presentationMode.wrappedValue.dismiss()  // Dismiss to go back
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
    ExportData()
}
