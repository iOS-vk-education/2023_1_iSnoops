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

    var isConnected: Bool = false // Проверяет, есть ли подключение к инету

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
