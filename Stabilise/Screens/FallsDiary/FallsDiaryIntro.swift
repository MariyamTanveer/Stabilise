import SwiftUI

struct FallRecord: Identifiable, Equatable {
    let id = UUID() // Unique ID for List
    let date: String
    let time: String
    let event: String
    let mechanism: String
    let activity: String
    let environment: String
    let cgState: Int
}

struct FallsDiaryIntro: View {
    @State private var fallRecords: [FallRecord] = []
    @Environment(\.presentationMode) var presentationMode  // For dismissing the view

    var body: some View {
        VStack {
            Text(NSLocalizedString("Falls_diary_heading", comment: ""))
                .modifier(TextStyles.styledHeadline())

            ScrollView {
                VStack(spacing: 16) {
                    ForEach(fallRecords) { record in
                        NavigationLink(
                            destination: FallsDiarySummary(
                            recordData: ["event": record.event, "date": record.date,
                                         "time": record.time, "mechanism": record.mechanism,
                                         "activity": record.activity, "cgState": record.cgState,
                                         "environment": record.environment],
                            isDraft: false
                            )
                        ) {
                            FallCardView(
                                record: record,
                                onDelete: { deleteFallRecord(record) }
                            )
                        }
                    }
                }
                .padding()
            }

            VStack {
                NavigationLink(destination: FallsDiaryQuestions()) {
                    Text(NSLocalizedString("Add", comment: ""))
                }
                .buttonStyle(AppButtonStyle(backgroundColor: AppColors.primary))

                // Replacing NavigationLink with a Button to go back
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
        .onAppear {
            fetchFallRecords()
        }
    }

    private func fetchFallRecords() {
        let userDefaults = UserDefaults.standard
        let allKeys = userDefaults.dictionaryRepresentation().keys

        let fallKeys = allKeys.filter { $0.hasPrefix("Falls_diary") }
        print(fallKeys)

        fallRecords = fallKeys.compactMap { key in
            if let value = userDefaults.dictionary(forKey: key) {
                return FallRecord(
                    date: value["date"] as? String ?? NSLocalizedString("unknown_date", comment: ""),
                    time: value["time"] as? String ?? NSLocalizedString("unknown_time", comment: ""),
                    event: value["event"] as? String ?? NSLocalizedString("unknown_event", comment: ""),
                    mechanism: value["mechanism"] as? String ?? NSLocalizedString("unknown_mechanism", comment: ""),
                    activity: value["activity"] as? String ?? NSLocalizedString("unknown_activity", comment: ""),
                    environment: value["environment"] as? String ?? NSLocalizedString("unknown_environment", comment: ""),
                    cgState: value["cgState"] as? Int ?? 0
                )
            }
            return nil
        }.sorted(by: { $0.date > $1.date })
    }

    private func deleteFallRecord(_ record: FallRecord) {
        let userDefaults = UserDefaults.standard
        let allKeys = userDefaults.dictionaryRepresentation().keys

        // Find the exact key to delete by matching the date and event
        if let keyToDelete = allKeys.first(where: { key in
            if key.hasPrefix("Falls_diary"),
               let value = userDefaults.dictionary(forKey: key),
               value["date"] as? String == record.date,
               value["event"] as? String == record.event {
                return true
            }
            return false
        }) {
            userDefaults.removeObject(forKey: keyToDelete)
        }

        // Remove from the in-memory list
        fallRecords.removeAll { $0 == record }
    }
    
    func navigateToSummary(record: FallRecord) -> some View {
        FallsDiarySummary(
            recordData: ["event": record.event, "date": record.date],
            isDraft: false // Indicates this is a submitted record
        )
    }
}

struct FallCardView: View {
    let record: FallRecord
    let onDelete: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(record.event)
                    .font(.system(size: 20, weight: .bold))
                Text(record.date)
                    .font(.system(size: 20))
            }
            Spacer()
            Button(action: {
                onDelete()
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(AppColors.textBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(AppColors.secondary, lineWidth: 1)
        )
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    FallsDiaryIntro()
}
