//
//  StabiliseApp.swift
//  Stabilise
//
//  Created by Mariyam Tanveer on 15/11/2024.
//

import SwiftUI
import Firebase

@main
struct StabiliseApp: App {
    init() {
        FirebaseApp.configure()
        
        BackgroundSyncManager.shared.registerBackgroundTask()
        BackgroundSyncManager.shared.scheduleDailySync()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
