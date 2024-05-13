//
//  AppDelegate.swift
//  easyLanguage
//
//  Created by Grigoriy on 24.10.2023.
//
// swiftlint:disable all
import UIKit
import FirebaseCore
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let pushManager = PushManager.shared

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        pushManager.requestAuth { [weak self] status in
            guard let self else {
                return
            }

            self.pushManager.getStatus { status in
                if status == .allowed {
                    self.sendNotification()
                }
            }
        }

        return true
    }

    //FIXME: - после создания статистики/достижений сделать осмысленными пуши
    //на крайняк можно сделать что чел прошел регистрацию , но при этом не создал ни 1 категории , можно сделать пуш, мол вернись в прил
    private func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "title"
        content.body = "body"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
        pushManager.add(notification: request)
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
// swiftlint:enable all
