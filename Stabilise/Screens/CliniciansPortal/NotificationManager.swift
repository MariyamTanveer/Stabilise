import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
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
        let defaults = UserDefaults.standard
        
        guard defaults.bool(forKey: "bannerNotification") else {
            print("Notifications are disabled")
            return
        }

        if let exerciseTime = defaults.object(forKey: "exerciseTime") as? Date {
            scheduleNotification(title: "Exercise Reminder", body: "Time to exercise!", date: exerciseTime)
        }
        
        if let questionnaireTime = defaults.object(forKey: "questionnaireTime") as? Date {
            scheduleNotification(title: "Questionnaire Reminder", body: "Time to fill out the questionnaire!", date: questionnaireTime)
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
