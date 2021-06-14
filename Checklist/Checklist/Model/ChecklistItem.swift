//
//  ChecklistItem.swift
//  Checklist
//
//  Created by Sabir Myrzaev on 10.06.2021.
//

import Foundation
import UserNotifications


class ChecklistItem: NSObject, Codable {
    var text = ""
    var checked = false
    var dueDate = Date()
    var shouldRemind = false
    var itemID = -1
    
    override init() {
        super.init()
        // запрашивает у DataModelобъекта новый идентификатор элемента
        // и заменяет начальное значение -1 этим уникальным идентификатором
        itemID = DataModel.nextChecklistItemID()
    }
    
    deinit {
        removeNotification()
    }
    
    // MARK: - Date notification
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])


    }
    
    func scheduleNotification() {
        removeNotification()
        // Оператор dueDate > Date()сравнивает две даты и возвращает, trueесли dueDateэто в будущем, и falseесли это в прошлом
        // Помещаем элемент text в сообщение с уведомлением
        if shouldRemind && dueDate > Date() {
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = text
            content.sound = UNNotificationSound.default
            
            // извлекаем дату из dueData
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
            
            // проверка локальных уведомлений
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            // идентификация уведомления
            let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
           
            // добавляем новое уведомление в center
            let center = UNUserNotificationCenter.current()
            center.add(request)
            print("Planned \(request) for itemID: \(itemID)")

        }
    }
}
