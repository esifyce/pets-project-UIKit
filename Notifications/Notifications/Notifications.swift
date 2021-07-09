//
//  Notifications.swift
//  Notifications
//
//  Created by Sabir Myrzaev on 09.07.2021.
//  Copyright © 2021 Alexey Efimov. All rights reserved.
//

import UIKit
import UserNotifications

class Notifications: NSObject, UNUserNotificationCenterDelegate {
    
    let notificatiionCenter = UNUserNotificationCenter.current()

    
    func requestAutorization() {
        notificatiionCenter.requestAuthorization(options: [.alert, .sound, .badge]) { [unowned self] granted, error in
            print("Permision granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    // возвращает параметр который выбрал пользователь
    func getNotificationSettings() {
        notificatiionCenter.getNotificationSettings { settings in
            print("Notification settings: \(settings)")
        }
    }
    
    func scheduleNotification(notificationType: String) {
        
        let content = UNMutableNotificationContent()
        let userAction = "User Action"
        
        content.title = notificationType
        content.body = "This is example how to create " + notificationType
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = userAction
        
        guard let path = Bundle.main.path(forResource: "testNotif", ofType: "png") else { return }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            let attachment = try UNNotificationAttachment(identifier: "testNotif", url: url, options: nil)
            content.attachments = [attachment]
        } catch {
            print("The attachment cold not be loaded")
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let identifire = "Local Notification"
        let request = UNNotificationRequest(identifier: identifire, content: content, trigger: trigger)
       
        notificatiionCenter.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
        let deleteAction = UNNotificationAction(identifier: "Delete", title: "Delete", options: [.destructive])
        let category = UNNotificationCategory(identifier: userAction,
                                              actions: [snoozeAction, deleteAction],
                                              intentIdentifiers: [],
                                              options: [])
        notificatiionCenter.setNotificationCategories([category])
    }
    
    // уведомление на переднем плане
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
    }
    
    // обработка уведомления при нажатии
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.notification.request.identifier == "Local Notification" {
            print("Handling notification with the Local Notification Identifire")
        }
        
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Default")
        case "Snooze":
            print("Snooze")
            scheduleNotification(notificationType: "Reminder")
        case "Delete":
            print("Delete")
        default:
            print("Unknown action")
        }
        
        completionHandler()
    }
}
