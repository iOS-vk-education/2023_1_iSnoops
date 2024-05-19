//
//  BackendSyncService.swift
//  easyLanguage
//
//  Created by Grigoriy on 19.05.2024.
//

import Foundation

/// с бека данные в coreData
protocol IBackendSyncService {
    
}

final class BackendSyncService {
    static let shared: IBackendSyncService = BackendSyncService()
    private init() {}
}

extension BackendSyncService: IBackendSyncService {
    
}
