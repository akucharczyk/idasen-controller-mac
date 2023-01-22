//
//  Notification.swift
//  Desk Controller
//
//  Created by Antoni Kucharczyk on 13.12.22.
//

import Foundation
import UserNotifications

class Notification: NSObject {
    let un = UNUserNotificationCenter.current()
    
    func requestAuthorization() {
        un.requestAuthorization(options: [.alert, .sound], completionHandler: { (auth, error) in
            if(!auth) {
                return print("Auth false")
            }
    
            print("Auth true")
        });
    }
    
    func sitDownTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + Preferences.shared.standUpInterval) {
            self.notification(title: "Sit Down", subtitle: "")
        }
    }
    
    func standUpTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + Preferences.shared.standUpInterval) {
            self.notification(title: "Stand Up", subtitle: "")
        }
    }
    
    func notification(
        title: String,
        subtitle: String
    ) {
        un.getNotificationSettings {(settings) in
            if settings.authorizationStatus == .authorized {
                let notificationContent = UNMutableNotificationContent()
                
                notificationContent.title = title
                notificationContent.subtitle = subtitle
                notificationContent.sound = UNNotificationSound.default
                
                let units: Set<Calendar.Component> = [.hour, .day, .month, .year]
                let comps = Calendar.current.dateComponents(units, from: Date())

                
                let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
                let id = "standUp"
                let request = UNNotificationRequest(identifier: id, content: notificationContent, trigger: trigger)
                
                self.un.add(request) {(error) in
                    if error != nil {
                        print(error?.localizedDescription as Any)
                    }
                }
            }
        }
    }
    
}
