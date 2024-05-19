//
//  NetworkMonitor.swift
//  easyLanguage
//
//  Created by Grigoriy on 19.05.2024.
//

import Foundation
import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)

    private init() {
        startMonitoring()
    }

    var isConnected: Bool = false {
        didSet {
            // вызов в файле SceneDelegate + SyncBackend
            NotificationCenter.default.post(name: .networkStatusChanged, object: nil)
        }
    }

    private func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}

extension Notification.Name {
    static let networkStatusChanged = Notification.Name("networkStatusChanged")
}
