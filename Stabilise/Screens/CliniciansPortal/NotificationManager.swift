//
//  NotificationManager.swift
//  Stabilise
//
//  Created by Mariyam Taveer on 13.02.25.
//


import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private let notificationCenter = UNUserNotificationCenter.current()
    private let defaults = UserDefaults.standard
    
    private init() {}

    func requestPermission() {
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notification permissions: \(error.localizedDescription)")
            } else {
                print("Notification permissions granted: \(granted)")
            }
        }
    }

    func scheduleNotifications() {
        guard defaults.bool(forKey: "bannerNotification") else {
            print("Notifications are disabled")
            return
        }
        
        let todayKey = Date().formatted(date: .numeric, time: .omitted)
        let exerciseKey = "Exercise-\(todayKey)"
        let questionnaireKey = "SubmittedAnswer-\(todayKey)"

        // Schedule exercise notification only if not submitted
        if defaults.object(forKey: exerciseKey) == nil,
           let exerciseTime = defaults.object(forKey: "exerciseTime") as? Date {
           scheduleNotification(
                title: "Don't skip your workout! 💪",
                body: "You haven't exercised today. Get moving and stay active!",
                date: exerciseTime
            )
        }
        
        // Schedule questionnaire notification only if not submitted
        if defaults.object(forKey: questionnaireKey) == nil,
           let questionnaireTime = defaults.object(forKey: "questionnaireTime") as? Date {
            scheduleNotification(
                title: "Quick check-in needed! 📝",
                body: "You haven't filled out your questionnaire today. Do it ASAP!",
                date: questionnaireTime
            )
        }
    }

    private func scheduleNotification(title: String, body: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let calendar = Calendar.current
        let triggerDate = calendar.dateComponents([.hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)

        let request = UNNotificationRequest(identifier: title, content: content, trigger: trigger)
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("\(title) notification scheduled for \(triggerDate.hour ?? 0):\(triggerDate.minute ?? 0)")
            }
        }
    }
}
