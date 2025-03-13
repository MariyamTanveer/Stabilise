//
//  BackgroundSyncManager.swift
//  Stabilise
//
//  Created by Mariyam Taveer on 13.03.25.
//

import Foundation
import BackgroundTasks

class BackgroundSyncManager {
    
    static let shared = BackgroundSyncManager()

    private init() {}

    // Register the background task
    func registerBackgroundTask() {
        print("🔵 Registering background task: com.stabilise.syncdata")
        BGTaskScheduler.shared.getPendingTaskRequests { tasks in
            print("Pending tasks: \(tasks)")
        }
        
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: "com.stabilise.syncdata",
            using: nil
        ) { task in
            self.handleSyncTask(task as! BGAppRefreshTask)
        }
    }

    // Schedule the background task for 11 PM daily
    func scheduleDailySync() {
        let request = BGAppRefreshTaskRequest(identifier: "com.stabilise.syncdata")
        request.earliestBeginDate = getNext11PMDate()
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("Scheduled daily sync for 11 PM")
        } catch {
            print("Failed to schedule daily sync: \(error.localizedDescription)")
        }
    }

    // Get the next occurrence of 11 PM
    private func getNext11PMDate() -> Date {
        let calendar = Calendar.current
        let now = Date()
        let elevenPM = calendar.date(bySettingHour: 03, minute: 11, second: 0, of: now)!

        return now > elevenPM ? calendar.date(byAdding: .day, value: 1, to: elevenPM)! : elevenPM
    }

    // Handle background task execution
    private func handleSyncTask(_ task: BGAppRefreshTask) {
        task.expirationHandler = {
            print("background task failed")
            task.setTaskCompleted(success: false)
        }
        print("Executing background sync task")
        FirestoreService.shared.syncDailyData { error in
            if let error = error {
                print("Background sync failed: \(error.localizedDescription)")
            } else {
                print("Background sync successful!")
            }
            task.setTaskCompleted(success: error == nil)
        }

        // Reschedule for the next day
        scheduleDailySync()
    }
}
