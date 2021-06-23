//
//  Functions.swift
//  MyLocations
//
//  Created by Sabir Myrzaev on 20.06.2021.
//

import Foundation

// задержка
func afterDelay(_ second: Double, run: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + second, execute: run)
}
// расположение хранилища данных в CoreData
let applicationDocumentsDirectory: URL = {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}()

let dataSaveFaileNotification = Notification.Name(rawValue: "DataSaveFailedNotification")

func fatalCoreDataError(_ error: Error) {
    print("*** Fatal error: \(error)")
    NotificationCenter.default.post(name: dataSaveFaileNotification, object: nil)
}
