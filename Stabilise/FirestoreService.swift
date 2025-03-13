//
//  FirestoreService.swift
//  Stabilise
//
//  Created by Mariyam Taveer on 06.02.25.
//


import FirebaseFirestore

class FirestoreService {
    static let shared = FirestoreService()
    private let db = Firestore.firestore()
    
    // Sync local storage data to Firestore
    func syncDailyData(completion: @escaping (Error?) -> Void) {
        let date = getCurrentDate() // Format: YYYY-MM-DD
        print("Starting Firestore sync for \(date)")
        
        // Fetch patient ID from local storage
        guard let patientId = UserDefaults.standard.string(forKey: "patientID") else {
            print("Error: No PatientID found in local storage.")
            completion(NSError(domain: "FirestoreSync", code: 1, userInfo: [NSLocalizedDescriptionKey: "Missing PatientID"]))
            return
        }
        
        // Fetch data from UserDefaults (local storage)
        let fallsDiary = UserDefaults.standard.dictionary(forKey: "Falls_diary-\(date)") ?? [:]
        let questionnaire = UserDefaults.standard.dictionary(forKey: "SubmittedAnswer-\(date)") ?? [:]
        let exercises = UserDefaults.standard.array(forKey: "Exercise-\(date)") as? [Int] ?? []

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
                if let error = error {
                    print("Firestore sync failed: \(error.localizedDescription)")
                } else {
                    print("Firestore sync successful at \(date)!")
                }
                completion(error)
            }
    }

    // Helper function to get today's date as a string
    private func getCurrentDate() -> String {
        return Date().formatted(date: .numeric, time: .omitted)
    }
}
