import FirebaseFirestore

class FirestoreService {
    static let shared = FirestoreService()
    private let db = Firestore.firestore()
    
    // Sync local storage data to Firestore
    func syncDailyData(patientId: String, completion: @escaping (Error?) -> Void) {
        let date = getCurrentDate() // Format: YYYY-MM-DD
        
        // Fetch data from UserDefaults (local storage)
        let fallsDiary = UserDefaults.standard.dictionary(forKey: "Falls_Diary-\(date)") ?? [:]
        let questionnaire = UserDefaults.standard.dictionary(forKey: "Questionnaire-\(date)") ?? [:]
        let exercises = UserDefaults.standard.dictionary(forKey: "Exercises-\(date)") ?? [:]

        // Prepare Firestore document
        let dailyData: [String: Any] = [
            "fallsDiary": fallsDiary,
            "questionnaire": questionnaire,
            "exercises": exercises,
            "syncedAt": Timestamp()
        ]

        // Store in Firestore under the correct patient and date
        db.collection("patients").document(patientId)
            .collection("dailyEntries").document(date)
            .setData(dailyData) { error in
                completion(error)
            }
    }

    // Helper function to get today's date as a string
    private func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"  // Example: 2025-02-06
        return formatter.string(from: Date())
    }
}
