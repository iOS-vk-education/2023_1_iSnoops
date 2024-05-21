//
//  SceneDelegate + SyncBackend.swift
//  easyLanguage
//
//  Created by Grigoriy on 19.05.2024.
//

import Foundation
import CoreData

extension SceneDelegate {
    func syncCDtoBackend() {
        if NetworkMonitor.shared.isConnected {
            print("есть инет")
            isNeedToUpdateBackend { needsUpdate in
                if needsUpdate {
                    self.updateBackend()
                } else {
                    self.updateCoreData()
                }
            }
        } else {
            isNeedToUpdateBackend { needsUpdate in
//                if needsUpdate {
//                    self.updateBackend()
//                } else {
//                    self.updateCoreData()
//                }
                self.updateCoreData()
            }
            print("нет инета")
        }
    }

    func setupNetworkMonitoring() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged),
            name: .networkStatusChanged, object: nil
        )
    }

    @objc private func networkStatusChanged(notification: Notification) {
        syncCDtoBackend()
    }
}

extension SceneDelegate {
    func isNeedToUpdateBackend(completion: @escaping (Bool) -> Void) {
        guard let latestLocalTime = coreData.fetchProfileTime() else {
            completion(false)
            return
        }

        ProfileService.shared.loadTime { result in
            switch result {
            case .success(let backendTime):
                if latestLocalTime > backendTime {
                    completion(true)
                } else {
                    completion(false)
                }
            case .failure(let error):
                print("Ошибка получения времени с бэка: \(error.localizedDescription)")
                completion(false)
            }
        }
    }

    func updateBackend() {
        print("updateBackend")
        // TODO: - вызвать синхонизацию coredataToBackend
//        CoreDataSyncService()
    }

    func updateCoreData() {
        print("updateCoreData")
//        coreData.deleteAllData()
        Task {
            do {
                await BackendSyncService.shared.syncAllDataToCoreData()
            }
        }
    }
}
