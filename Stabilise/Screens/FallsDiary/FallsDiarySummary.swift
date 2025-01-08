import SwiftUI

struct FallsDiarySummary: View {
    @State private var draftData: [String: Any] = [:]
    @State private var showAlert = false
    @State private var navigationPath: [NavigationDestination] = [] // For programmatic navigation
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                Text("Summary")
                    .modifier(TextStyles.styledHeadline())
                
                Spacer()
                
                if !draftData.isEmpty {
                    VStack(alignment: .leading, spacing: 40) {
                        SummaryRow(title: "Date", value: draftData["date"] as? String ?? "")
                        SummaryRow(title: "Time", value: draftData["time"] as? String ?? "")
                        SummaryRow(title: "Event", value: draftData["event"] as? String ?? "")
                        SummaryRow(title: "Activity", value: draftData["activity"] as? String ?? "")
                        SummaryRow(title: "Mechanism", value: draftData["mechanism"] as? String ?? "")
                        SummaryRow(title: "CG Therapy", value: (draftData["cgstate"] as? Int == 1) ? "On" : "Off")
                    }
                    .padding()
                    .background(AppColors.textBackground)
                    .cornerRadius(20)
                    .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 5)
                    .padding(.horizontal)
                } else {
                    Text("No draft data available.")
                        .font(.body)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                VStack {
                    Button(action: submitRecord) {
                        Text(NSLocalizedString("Submit", comment: "Submit"))
                    }
                    .buttonStyle(AppButtonStyle())
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Record Submitted"),
                            message: Text("The record has been successfully submitted."),
                            dismissButton: .default(Text("OK"), action: {
                                navigationPath.append(.intro) // Navigate to FallsDiaryIntro
                            })
                        )
                    }
                    
                    NavigationLink(value: NavigationDestination.questions) {
                        Text(NSLocalizedString("Back", comment: "Back Button"))
                    }
                    .buttonStyle(AppButtonStyle(backgroundColor: AppColors.secondary))
                }
                .padding(.bottom, 1)
            }
            .onAppear {
                fetchDraftFallsDiaryData()
            }
            .padding()
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .intro:
                    FallsDiaryIntro()
                case .questions:
                    FallsDiaryQuestions()
                }
            }
        }
    }
    
    // fetch draft data
    func fetchDraftFallsDiaryData() {
        let defaults = UserDefaults.standard
        let keys = defaults.dictionaryRepresentation().keys
        var fetchedData: [String: Any] = [:]

        for key in keys where key.hasPrefix("draft_falls_diary") {
            if let value = defaults.object(forKey: key) as? [String: Any] {
                fetchedData = value
                break
            }
        }

        DispatchQueue.main.async {
            draftData = fetchedData
        }
    }
    
    func submitRecord() {
        guard !draftData.isEmpty else { return }
        
        let defaults = UserDefaults.standard
        
        // Remove draft data
        for key in defaults.dictionaryRepresentation().keys where key.hasPrefix("draft_falls_diary") {
            defaults.removeObject(forKey: key)
        }
        
        // Save with new key
        if let date = draftData["date"] as? String, let time = draftData["time"] as? String {
            let newKey = "Falls_diary_\(date)_\(time)"
            defaults.set(draftData, forKey: newKey)
        }
        
        // Show the alert
        showAlert = true
    }
}

enum NavigationDestination: Hashable {
    case intro
    case questions
}

struct SummaryRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .fontWeight(.semibold)
                .font(.system(size: 22))
            Spacer()
            Text(value)
                .font(.system(size: 22))
        }
        .font(.body)
    }
}

#Preview {
    FallsDiarySummary()
}
