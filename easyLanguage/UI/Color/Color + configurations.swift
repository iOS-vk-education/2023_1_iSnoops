//
//  Color.swift
//  easyLanguage
//
//  Created by Grigoriy on 25.10.2023.
//

import UIKit
// swiftlint:disable nesting
extension UIColor {
    struct PrimaryColors {
        struct Background {
            static let background: UIColor = Color(lightMode: UIColor(hex: "F6F6F6") ?? .white).currentColor
        }
        struct Button {
            static let blue: UIColor = Color(lightMode: UIColor(hex: "3478F6") ?? .white).currentColor
        }
    }

    struct SecondaryColors {
        struct ProgressView {
            static let gray: UIColor = Color(lightMode: UIColor(hex: "D9D9D9") ?? .white).currentColor
            static let green: UIColor = Color(lightMode: UIColor(hex: "6CDC72") ?? .white).currentColor
        }
    }

    struct Catalog {
        struct Pink {
            static let topFiveBackground: UIColor = Color(lightMode: UIColor(hex: "E3A8BE") ?? .white).currentColor
            static let topFiveBackText: UIColor = Color(lightMode: UIColor(hex: "713D4F") ?? .white).currentColor
            static let categoryBackground: UIColor = Color(lightMode: UIColor(hex: "DDB1E8") ?? .white).currentColor
            static let categoryText: UIColor = Color(lightMode: UIColor(hex: "872E6E") ?? .white).currentColor
        }

        struct Yellow {
            static let topFiveBackground: UIColor = Color(lightMode: UIColor(hex: "F8DDA8") ?? .white).currentColor
            static let topFiveBackText: UIColor = Color(lightMode: UIColor(hex: "8C6D2E") ?? .white).currentColor
            static let categoryBackground: UIColor = Color(lightMode: UIColor(hex: "FAC252") ?? .white).currentColor
            static let categoryText: UIColor = Color(lightMode: UIColor(hex: "8E6A23") ?? .white).currentColor
        }

        struct Blue {
            static let topFiveBackground: UIColor = Color(lightMode: UIColor(hex: "ADC0DB") ?? .white).currentColor
            static let topFiveBackText: UIColor = Color(lightMode: UIColor(hex: "1D3D69") ?? .white).currentColor
            static let categoryBackground: UIColor = Color(lightMode: UIColor(hex: "94C3DE") ?? .white).currentColor
            static let categoryText: UIColor = Color(lightMode: UIColor(hex: "261F51") ?? .white).currentColor
        }

        struct Green {
            static let categoryBackground: UIColor = Color(lightMode: UIColor(hex: "ACD4AF") ?? .white).currentColor
            static let categoryText: UIColor = Color(lightMode: UIColor(hex: "1E4221") ?? .white).currentColor
        }

        struct Purple {
            static let categoryBackground: UIColor = Color(lightMode: UIColor(hex: "B6A8CD") ?? .white).currentColor
            static let categoryText: UIColor = Color(lightMode: UIColor(hex: "4A3965") ?? .white).currentColor
        }

        struct LightYellow {
            static let categoryBackground: UIColor = Color(lightMode: UIColor(hex: "EDE38A") ?? .white).currentColor
            static let categoryText: UIColor = Color(lightMode: UIColor(hex: "847B2C") ?? .white).currentColor
        }

        struct Cyan {
            static let categoryBackground: UIColor = Color(lightMode: UIColor(hex: "ABDDD7") ?? .white).currentColor
            static let categoryText: UIColor = Color(lightMode: UIColor(hex: "146B56") ?? .white).currentColor
        }

        struct Red {
            static let categoryBackground: UIColor = Color(lightMode: UIColor(hex: "DE9494") ?? .white).currentColor
            static let categoryText: UIColor = Color(lightMode: UIColor(hex: "653939") ?? .white).currentColor
        }
    }
}
// swiftlint:enable nesting
