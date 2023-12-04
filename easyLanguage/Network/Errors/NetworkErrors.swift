//
//  NetworkErrors.swift
//  easyLanguage
//
//  Created by Grigoriy on 25.11.2023.
//

import Foundation

enum NetworkError: Error {
    case unexpectedError
    case idError
    case urlError
    case emptyData
}
