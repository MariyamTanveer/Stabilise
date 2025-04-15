import SwiftUI

struct FallsDiaryQuestions: View {
    @State private var date = Date()
    @State private var approximateTime = Date()
    @State private var eventType = NSLocalizedString("select_event_type", comment: "")
    @State private var environment = NSLocalizedString("select_environment", comment: "")
    @State private var activity = NSLocalizedString("select_activity", comment: "")
    @State private var fallMechanism = NSLocalizedString("select_mechanism", comment: "")
    @State private var cgTherapyState = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showDetails = false
    
    @Environment(\.presentationMode) var presentationMode  // For dismissing the view
    
    var body: some View {
        VStack(spacing: 20) {
            Text(NSLocalizedString("falls_diary", comment: ""))
                .modifier(TextStyles.styledHeadline())
            
            VStack(spacing: 15) {
                DatePicker(NSLocalizedString("date", comment: ""), selection: $date, in: ...Date(), displayedComponents: .date)
                    .dropDownStyle()
                
                DatePicker(NSLocalizedString("time", comment: ""), selection: $approximateTime, displayedComponents: .hourAndMinute)
                    .dropDownStyle()
                
                DropdownField(title: $eventType, options: [
                    NSLocalizedString("fall", comment: ""),
                    NSLocalizedString("near_fall", comment: ""),
                    NSLocalizedString("sway", comment: "")
                ])
                
                DropdownField(title: $environment, options: [
                    NSLocalizedString("outdoor", comment: ""),
                    NSLocalizedString("indoor_light", comment: ""),
                    NSLocalizedString("indoor_dark", comment: ""),
                    NSLocalizedString("busy_place", comment: ""),
                    NSLocalizedString("constrained_place", comment: ""),
                    NSLocalizedString("other", comment: "")
                ])
                
                DropdownField(title: $activity, options: [
                    NSLocalizedString("walking", comment: ""),
                    NSLocalizedString("running", comment: ""),
                    NSLocalizedString("standing", comment: ""),
                    NSLocalizedString("stairs_up", comment: ""),
                    NSLocalizedString("stairs_down", comment: ""),
                    NSLocalizedString("sitting", comment: ""),
                    NSLocalizedString("cycling", comment: ""),
                    NSLocalizedString("sport", comment: "")
                ])
                

                DropdownField(title: $fallMechanism, options: [
                    NSLocalizedString("freefall", comment: ""),
                    NSLocalizedString("dizziness_vertigo", comment: ""),
                    NSLocalizedString("tripping", comment: ""),
                    NSLocalizedString("impaired_consciousness", comment: ""),
                    NSLocalizedString("other", comment: "")
                ])
                
                Toggle(NSLocalizedString("cg_therapy_state", comment: ""), isOn: $cgTherapyState)
                    .dropDownStyle()
            }
            .padding(.bottom, 10)
            
            VStack {
                Button(NSLocalizedString("save", comment: "")) {
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
        let dateString = Date().formatted(date: .numeric, time: .omitted)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let timeString = timeFormatter.string(from: approximateTime)
        
        let draftData: [String: Any] = [
            "date": dateString,
            "time": timeString,
            "event": eventType == "Select event type" ? "NA" : eventType,
            "environment": environment == "Select environment" ? "NA" : environment,
            "activity": activity == "Select activity" ? "NA" : activity,
            "mechanism": fallMechanism == "Select mechanism" ? "NA" : fallMechanism,
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
