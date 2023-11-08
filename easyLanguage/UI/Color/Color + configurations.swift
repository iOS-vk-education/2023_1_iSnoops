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
            static let customBackground: UIColor = Color(lightMode: UIColor(hex: "F6F6F6") ?? .white).currentColor
        }
    }

    struct SecondaryColors {
        struct ProgressView {
            static let customGray: UIColor = Color(lightMode: UIColor(hex: "D9D9D9") ?? .white).currentColor
            static let customGreen: UIColor = Color(lightMode: UIColor(hex: "6CDC72") ?? .white).currentColor
        }
    }

    struct Catalog {
        struct TopFive {
            struct Views {
                static let customPink: UIColor = Color(lightMode: UIColor(hex: "E3A8BE") ?? .white).currentColor
                static let customYellow: UIColor = Color(lightMode: UIColor(hex: "F8DDA8") ?? .white).currentColor
                static let customBlue: UIColor = Color(lightMode: UIColor(hex: "ADC0DB") ?? .white).currentColor
            }
            struct Fonts {
                static let customPink: UIColor = Color(lightMode: UIColor(hex: "713D4F") ?? .white).currentColor
                static let customYellow: UIColor = Color(lightMode: UIColor(hex: "8C6D2E") ?? .white).currentColor
                static let customBlue: UIColor = Color(lightMode: UIColor(hex: "1D3D69") ?? .white).currentColor
            }
        }

        struct Category {
            struct Views {
                static let customGreen: UIColor = Color(lightMode: UIColor(hex: "ACD4AF") ?? .white).currentColor
                static let customPurple: UIColor = Color(lightMode: UIColor(hex: "B6A8CD") ?? .white).currentColor
                static let customLightYellow: UIColor = Color(lightMode: UIColor(hex: "EDE38A") ?? .white).currentColor
                static let customYellow: UIColor = Color(lightMode: UIColor(hex: "FAC252") ?? .white).currentColor
                static let customRed: UIColor = Color(lightMode: UIColor(hex: "DE9494") ?? .white).currentColor
                static let customBlue: UIColor = Color(lightMode: UIColor(hex: "94C3DE") ?? .white).currentColor
                static let customCyan: UIColor = Color(lightMode: UIColor(hex: "ABDDD7") ?? .white).currentColor
                static let customPink: UIColor = Color(lightMode: UIColor(hex: "DDB1E8") ?? .white).currentColor
            }
            struct Fonts {
                static let customGreen: UIColor = Color(lightMode: UIColor(hex: "1E4221") ?? .white).currentColor
                static let customPurple: UIColor = Color(lightMode: UIColor(hex: "4A3965") ?? .white).currentColor
                static let customLightYellow: UIColor = Color(lightMode: UIColor(hex: "847B2C") ?? .white).currentColor
                static let customYellow: UIColor = Color(lightMode: UIColor(hex: "8E6A23") ?? .white).currentColor
                static let customRed: UIColor = Color(lightMode: UIColor(hex: "653939") ?? .white).currentColor
                static let customBlue: UIColor = Color(lightMode: UIColor(hex: "261F51") ?? .white).currentColor
                static let customCyan: UIColor = Color(lightMode: UIColor(hex: "146B56") ?? .white).currentColor
                static let customPink: UIColor = Color(lightMode: UIColor(hex: "872E6E") ?? .white).currentColor
            }
        }
    }
}
// swiftlint:enable nesting
