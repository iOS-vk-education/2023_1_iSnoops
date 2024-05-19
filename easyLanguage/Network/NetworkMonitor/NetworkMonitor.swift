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
    var connectionType: NWInterface.InterfaceType? // Проверяет тип подключения

    private func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
            self.connectionType = self.getConnectionType(path)
        }
        monitor.start(queue: queue)
    }

    private func getConnectionType(_ path: NWPath) -> NWInterface.InterfaceType? {
        if path.usesInterfaceType(.wifi) {
            return .wifi
        } else if path.usesInterfaceType(.cellular) {
            return .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            return .wiredEthernet
        } else {
            return nil
        }
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
