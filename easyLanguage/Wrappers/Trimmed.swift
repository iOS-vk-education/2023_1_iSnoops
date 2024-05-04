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
            let trimmedAndLowercased = newValue.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            var filteredString = ""
            var previousCharacter: Character?

            for character in trimmedAndLowercased {
                if character == " " {
                    if previousCharacter != " " {
                        filteredString.append(character)
                    }
                } else if character.isLetter || character.isWhitespace {
                    filteredString.append(character)
                }
                previousCharacter = character
            }

            value = filteredString

            if value != newValue {
                projectedValue = true
            } else {
                projectedValue = false
            }
        }
    }

    init(wrappedValue: String) {
        self.wrappedValue = wrappedValue
    }
}
