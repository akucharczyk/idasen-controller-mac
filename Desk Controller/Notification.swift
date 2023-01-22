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
  var viewController: ViewController?
  var timer: Timer?
  
  
  
  func requestAuthorization() {
    un.requestAuthorization(options: [.alert, .sound], completionHandler: { (auth, error) in
      if(!auth) {
        return print("Auth false")
      }
      
      print("Auth true")
    });
  }
  
  func sitDownTimer() {
    invalidateNotification(identifier: "STAND_UP")
    
    sendNotificationAfterDelay(
      title: "Sit Down",
      body: "It`s time to Sit Down",
      seconds: Preferences.shared.sitDownInterval,
      identifier: "SIT_DOWN",
      action: UNNotificationAction(
        identifier: "SIT_DOWN_ACTION",
        title: "Sit Down",
        options: []
      )
    )
  }
  
  
  func standUpTimer() {
    invalidateNotification(identifier: "SIT_DOWN")
    
    sendNotificationAfterDelay(
      title: "Stand Up",
      body: "It`s time to Stand Up",
      seconds: Preferences.shared.sitDownInterval,
      identifier: "STAND_UP",
      action: UNNotificationAction(
        identifier: "STAND_UP_ACTION",
        title: "Stand Up",
        options: []
      )
    )
  }
  
  func sendNotificationAfterDelay(title: String, body: String, seconds: Double, identifier: String, action: UNNotificationAction) {
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.categoryIdentifier = "DESK_NOTIFICATION"
    
    let deskActionCategory = UNNotificationCategory(
      identifier: "DESK_NOTIFICATION",
      actions: [action],
      intentIdentifiers: [],
      hiddenPreviewsBodyPlaceholder: "",
      options: .customDismissAction
    )
    
    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
    
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.add(request) { (error) in
      if let error = error {
        print("Error: \(error)")
      }
    }
    notificationCenter.setNotificationCategories([deskActionCategory])
  }
  
  func invalidateNotification(identifier: String) {
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
  }
}
