import SwiftUI

struct FallRecord: Identifiable {
    let id = UUID() // Unique ID for List
    let date: String
    let time: String
    let event: String
    let environment: String
}

struct FallsDiaryIntro: View {
    @State private var fallRecords: [FallRecord] = []

    var body: some View {
        VStack {
            
            Text(NSLocalizedString("Falls_diary_heading", comment: ""))
                .modifier(TextStyles.styledHeadline())

            ScrollView {
                VStack(spacing: 16) {
                    ForEach(fallRecords) { record in
                        FallCardView(record: record)
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

    private func fetchFallRecords() {
        let userDefaults = UserDefaults.standard
        let allKeys = userDefaults.dictionaryRepresentation().keys

        // Filter keys starting with "Falls_diary"
        let fallKeys = allKeys.filter { $0.hasPrefix("Falls_diary") }
        
        // Parse each record associated with the filtered keys
        fallRecords = fallKeys.compactMap { key in
            if let value = userDefaults.dictionary(forKey: key) {
                return FallRecord(
                    date: value["date"] as? String ?? "Unknown Date",
                    time: value["time"] as? String ?? "Unknown Time",
                    event: value["event"] as? String ?? "Unknown Event",
                    environment: value["environment"] as? String ?? "Unknown Environment"
                )
            }
            return nil
        }.sorted(by: { $0.date > $1.date }) // Sort records by date in descending order
    }
}

struct FallCardView: View {
    let record: FallRecord

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(record.event)
                    .font(.system(size: 20, weight: .bold))
                Text(record.date)
                    .font(.system(size: 20))
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(AppColors.textBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(AppColors.secondary, lineWidth: 1) // Apply border
        )
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    FallsDiaryIntro()
}
