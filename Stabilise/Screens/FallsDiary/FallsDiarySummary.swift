import SwiftUI

struct FallsDiarySummary: View {
    var recordData: [String: Any]? // Optional for handling both draft and saved records
    var isDraft: Bool = true       // Flag to control the Submit button visibility

    @State private var draftData: [String: Any] = [:]
    @State private var showAlert = false
    @State private var isShowingNextDestination: Bool = false

    @Environment(\.presentationMode) var presentationMode  // For dismissing the view
    
    var body: some View {
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
                    SummaryRow(title: "CG Therapy", value: (draftData["cgState"] as? Int == 1) ? "On" : "Off")
                }
                .padding()
                .background(AppColors.textBackground)
                .cornerRadius(20)
                .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 5)
                .padding(.horizontal)
            } else {
                Text("No data available.")
                    .font(.body)
                    .foregroundColor(.gray)
            }

            Spacer()

            VStack {
                if isDraft {
                    Button(action: submitRecord) {
                        Text(NSLocalizedString("Submit", comment: "Submit"))
                    }
                    .buttonStyle(AppButtonStyle())
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Record Submitted"),
                            message: Text("The record has been successfully submitted."),
                            dismissButton: .default(Text("OK"), action: {
                                isShowingNextDestination = true
                            })
                        )
                    }.navigationDestination(isPresented: $isShowingNextDestination) {
                        FallsDiaryIntro()
                    }
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
        .onAppear {
            if let recordData = recordData {
                draftData = recordData // For saved records
            } else {
                fetchDraftFallsDiaryData() // For drafts
            }
        }
        .padding()
    }

    // Fetch draft data
    func fetchDraftFallsDiaryData() {
        let defaults = UserDefaults.standard
        let keys = defaults.dictionaryRepresentation().keys

        for key in keys where key.hasPrefix("draft_falls_diary") {
            if let value = defaults.object(forKey: key) as? [String: Any] {
                draftData = value
                break
            }
        }
    }

    // Submit draft record
    func submitRecord() {
        guard !draftData.isEmpty else { return }

        let defaults = UserDefaults.standard

        // Remove draft
        for key in defaults.dictionaryRepresentation().keys where key.hasPrefix("draft_falls_diary") {
            defaults.removeObject(forKey: key)
        }

        // Save as a final record
        if let date = draftData["date"] as? String, let time = draftData["time"] as? String {
            let newKey = "Falls_diary_\(date)_\(time)"
            defaults.set(draftData, forKey: newKey)
        }

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
