import SwiftUI

struct FallsDiaryQuestions: View {
    @State private var date = Date()
    @State private var approximateTime = Date()
    @State private var eventType = "Select event type"
    @State private var environment = "Select environment"
    @State private var activity = "Select activity"
    @State private var fallMechanism = "Select mechanism"
    @State private var cgTherapyState = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showDetails = false
    
    @Environment(\.presentationMode) var presentationMode  // For dismissing the view
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Falls Diary")
                .modifier(TextStyles.styledHeadline())
            
            VStack(spacing: 15) {
                DatePicker("Date", selection: $date, in: ...Date(), displayedComponents: .date)
                    .dropDownStyle()
                
                DatePicker("Time", selection: $approximateTime, displayedComponents: .hourAndMinute)
                    .dropDownStyle()
                
                DropdownField(title: $eventType, options: ["Fall", "Near Fall", "Sway"])
                DropdownField(title: $environment, options: ["Outdoor", "Indoor Light", "Indoor Dark", "Busy Place", "Constrained Place", "Other"])
                DropdownField(title: $activity, options: ["Walking", "Running", "Standing", "Stairs Up", "Stairs Down", "Sitting", "Cycling", "Sport"])
                DropdownField(title: $fallMechanism, options: ["Freefall", "Dizziness/Vertigo", "Tripping", "Impaired Consciousness", "Other"])
                
                Toggle("CG Therapy State", isOn: $cgTherapyState)
                    .dropDownStyle()
            }
            .padding(.bottom, 10)
            
            VStack {
                Button("Save") {
                    showDetails = true;
                    saveDraft();
                }
                .buttonStyle(AppButtonStyle(backgroundColor: AppColors.primary))
                .navigationDestination(isPresented: $showDetails) {
                    FallsDiarySummary()
                }
                
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
    
    private func validateAndSave() {
        // Validation logic
        var missingFields: [String] = []
        if eventType == "Select event type" { missingFields.append("Event Type") }
        if environment == "Select environment" { missingFields.append("Environment") }
        if activity == "Select activity" { missingFields.append("Activity") }
        if fallMechanism == "Select mechanism" { missingFields.append("Fall Mechanism") }
        
        // Check if there are missing fields
        if !missingFields.isEmpty {
            alertMessage = "Please select: \(missingFields.joined(separator: ", "))"
            showAlert = true
        } else {
            saveDraft()
        }
    }
    
    private func saveDraft() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let timeString = timeFormatter.string(from: approximateTime)
        
        let draftData: [String: Any] = [
            "date": dateString,
            "time": timeString,
            "event": eventType,
            "environment": environment,
            "activity": activity,
            "mechanism": fallMechanism,
            "cgstate": cgTherapyState
        ]
        
        // Use both dateString and timeString in the key
        let key = "draft_falls_diary-\(dateString)-\(timeString)"
        UserDefaults.standard.set(draftData, forKey: key)
        
        printDraft(key: key)
    }
    
    private func printDraft(key: String) {
        if let savedDraft = UserDefaults.standard.dictionary(forKey: key) {
            print("Saved Draft: \(savedDraft)")
        } else {
            print("No draft found for key \(key)")
        }
    }
}


#Preview {
    FallsDiaryQuestions()
}
