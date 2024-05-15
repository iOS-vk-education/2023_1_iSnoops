//
//  PushManager.swift
//  easyLanguage
//
//  Created by Grigoriy on 05.05.2024.
//

import Foundation
import UserNotifications

protocol IPushManager {
    func getStatus(completion: @escaping((PushStatus) -> Void))
    func requestAuth(completion: @escaping((PushStatus) -> Void))
    func add(notification: UNNotificationRequest)
}

final class PushManager {

    private init() {}

    static let shared: IPushManager = PushManager()
}

extension PushManager: IPushManager {
    func getStatus(completion: @escaping((PushStatus) -> Void)) {

        let mainThreadCompletion: ((PushStatus) -> Void) = { status in
            DispatchQueue.main.async {
                completion(status)
            }
        }

        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined: // статус до того как прил запросил доступ
                mainThreadCompletion(.unknown)
            case .denied:
                mainThreadCompletion(.denied)
            case .authorized:
                mainThreadCompletion(.allowed)
            case .provisional: // пуши не интерактивные (некликабельные)
                mainThreadCompletion(.unknown)
            case .ephemeral:
                mainThreadCompletion(.unknown)
            @unknown default:
                mainThreadCompletion(.unknown)
            }
        }
    }

    func requestAuth(completion: @escaping ((PushStatus) -> Void)) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                completion(granted ? .allowed : .denied)
            }
        }
    }

    func add(notification: UNNotificationRequest) {
        UNUserNotificationCenter.current().add(notification)
    }
}
