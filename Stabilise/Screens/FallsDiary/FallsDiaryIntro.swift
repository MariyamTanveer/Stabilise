import SwiftUI

struct FallRecord: Identifiable, Equatable {
    let id = UUID()
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

    var body: some View {
        NavigationView {
            VStack {
                Text(NSLocalizedString("Falls_diary_heading", comment: ""))
                    .modifier(TextStyles.styledHeadline())

                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(fallRecords) { record in
                            NavigationLink(destination: FallsDiarySummary(
                                recordData: [
                                    "date": record.date,
                                    "time": record.time,
                                    "event": record.event,
                                    "mechanism": record.mechanism,
                                    "activity": record.activity,
                                    "environment": record.environment,
                                    "cgState": record.cgState
                                ],
                                isDraft: false // Hide Submit button for saved records
                            )) {
                                FallCardView(record: record) {
                                    deleteFallRecord(record)
                                }
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

                    NavigationLink(destination: ContentView()) {
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
    }

    private func fetchFallRecords() {
        let userDefaults = UserDefaults.standard
        let allKeys = userDefaults.dictionaryRepresentation().keys

        let fallKeys = allKeys.filter { $0.hasPrefix("Falls_diary") }

        fallRecords = fallKeys.compactMap { key in
            if let value = userDefaults.dictionary(forKey: key) {
                return FallRecord(
                    date: value["date"] as? String ?? "Unknown Date",
                    time: value["time"] as? String ?? "Unknown Time",
                    event: value["event"] as? String ?? "Unknown Event",
                    mechanism: value["mechanism"] as? String ?? "Unknown Mechanism",
                    activity: value["activity"] as? String ?? "Unknown Activity",
                    environment: value["environment"] as? String ?? "Unknown Environment",
                    cgState: value["cgState"] as? Int ?? 0
                )
            }
            return nil
        }.sorted(by: { $0.date > $1.date })
    }

    private func deleteFallRecord(_ record: FallRecord) {
        let userDefaults = UserDefaults.standard
        let allKeys = userDefaults.dictionaryRepresentation().keys

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

        fallRecords.removeAll { $0 == record }
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
