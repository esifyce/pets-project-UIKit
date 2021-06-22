//
//  SceneDelegate.swift
//  MyLocations
//
//  Created by Sabir Myrzaev on 19.06.2021.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    lazy var managedObjectContext = persistentContainer.viewContext


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        let tabController = window!.rootViewController as! UITabBarController
        
        if let tabViewControllers = tabController.viewControllers {
            var navController = tabViewControllers[0] as! UINavigationController
            
            let controller1 = navController.viewControllers.first as! CurrentLocationViewController
            controller1.managedObjectContext = managedObjectContext
            
            // дает ссылку на контекст управляемого объекта
            navController = tabViewControllers[1] as! UINavigationController
            let controller2 = navController.viewControllers.first as! LocationsViewController
            controller2.managedObjectContext = managedObjectContext
            
            navController = tabViewControllers[2] as! UINavigationController
            let controller3 = navController.viewControllers.first as! MapViewController
            controller3.managedObjectContext = managedObjectContext
        }
        listenForFatalCoreDataNotifications()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
        saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MyLocations")
        // загружает данные из базы данных в память и настраивает стек Core Data
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
// MARK: - Helper methods
    func listenForFatalCoreDataNotifications() {
        // Сообщаем, что зочу получать уведомление публикации
        NotificationCenter.default.addObserver(forName: dataSaveFaileNotification, object: nil, queue: OperationQueue.main) { _ in
        
            let message = """
                В приложении произошла фатальная ошибка и оно не может быть продолжено.
                
                Наэмите ОК, чтобы закрыть приложение. Извините за причиненные неудобства.
                """
            let alert = UIAlertController(title: "Internal error", message: message, preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default) { _ in
                // вместо fatalError используем NSException, создает объект для завершения приложения, это лучше и дает больше информации в журнал сбоев
                let exception = NSException(name: NSExceptionName.internalInconsistencyException, reason: "Неустранимая ошибка основных данных", userInfo: nil)
                exception.raise()
            }
            alert.addAction(action)
            
            guard let tabController = self.window!.rootViewController else { return }
            tabController.present(alert, animated: true, completion: nil)
            
        }
    }
}

