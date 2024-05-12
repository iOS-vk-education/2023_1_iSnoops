//
//  Trimmed.swift
//  easyLanguage
//
//  Created by Grigoriy on 10.03.2024.
//

import Foundation

/// удаляет ненужные пробелы и переводы на  новую строку
/// "  example   " =>  "example"
@propertyWrapper
struct Trimmed {
    private(set) var value = ""
    var projectedValue = false

    var wrappedValue: String {
        get {
            return value
        }
        set {
            value = newValue
                .lowercased()
                .filter { $0.isLetter || $0.isWhitespace }
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .split(separator: " ")
                .joined(separator: " ")

            projectedValue = value != newValue
        }
    }

    init(wrappedValue: String) {
        self.wrappedValue = wrappedValue
    }
}
