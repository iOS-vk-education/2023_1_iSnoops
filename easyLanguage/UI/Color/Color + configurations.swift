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
            static let customBackground: UIColor = Color(lightMode: prilGrayLightF6F6F6).currentColor
        }
    }

    struct SecondaryColors {
        struct ProgressView {
            static let customGray: UIColor = Color(lightMode: prilGrayD9D9D9).currentColor
            static let customGreen: UIColor = Color(lightMode: prilGreen6CDC72).currentColor
        }
    }

    struct Catalog {
        struct TopFive {
            struct Views {
                static let customPink: UIColor = Color(lightMode: prilPinkE3A8BE).currentColor
                static let customYellow: UIColor = Color(lightMode: prilYellowF8DDA8).currentColor
                static let customBlue: UIColor = Color(lightMode: prilBlueADC0DB).currentColor
            }
            struct Fonts {
                static let customPink: UIColor = Color(lightMode: prilDarkPink713D4F).currentColor
                static let customYellow: UIColor = Color(lightMode: prilDarkYellow8C6D2E).currentColor
                static let customBlue: UIColor = Color(lightMode: prilDarkBlue1D3D69).currentColor
            }
        }

        struct Category {
            struct Views {
                static let customGreen: UIColor = Color(lightMode: prilGreenACD4AF).currentColor
                static let customPurple: UIColor = Color(lightMode: prilPurpleB6A8CD).currentColor
                static let customLightYellow: UIColor = Color(lightMode: prilLightYellowEDE38A).currentColor
                static let customYellow: UIColor = Color(lightMode: prilYellowFAC252).currentColor
                static let customRed: UIColor = Color(lightMode: prilRedDE9494).currentColor
                static let customBlue: UIColor = Color(lightMode: prilBlue94C3DE).currentColor
                static let customCyan: UIColor = Color(lightMode: prilCyanABDDD7).currentColor
                static let customPink: UIColor = Color(lightMode: prilPinkDDB1E8).currentColor
            }
            struct Fonts {
                static let customGreen: UIColor = Color(lightMode: prilGreen1E4221).currentColor
                static let customPurple: UIColor = Color(lightMode: prilPurple4A3965).currentColor
                static let customLightYellow: UIColor = Color(lightMode: prilLightYellow847B2C).currentColor
                static let customYellow: UIColor = Color(lightMode: prilYellow8E6A23).currentColor
                static let customRed: UIColor = Color(lightMode: prilRed653939).currentColor
                static let customBlue: UIColor = Color(lightMode: prilBlue261F51).currentColor
                static let customCyan: UIColor = Color(lightMode: prilCyan146B56).currentColor
                static let customPink: UIColor = Color(lightMode: prilPink872E6E).currentColor
            }
        }
    }
}
// swiftlint:enable nesting
private extension UIColor {
    static let prilGreen506C4B = UIColor(hex: "#506C4B") ??  Default.color
    // MARK: - LightMode

    // Top five Cell
    static let prilPinkE3A8BE = UIColor(hex: "E3A8BE") ?? Default.color
    static let prilYellowF8DDA8 = UIColor(hex: "F8DDA8") ?? Default.color
    static let prilBlueADC0DB = UIColor(hex: "ADC0DB") ?? Default.color

    // ProgressView
    static let prilGrayD9D9D9 = UIColor(hex: "D9D9D9") ?? Default.color
    static let prilGreen6CDC72 = UIColor(hex: "6CDC72") ?? Default.color

    // Font Top Five
    static let prilDarkPink713D4F = UIColor(hex: "713D4F") ?? Default.color
    static let prilDarkYellow8C6D2E = UIColor(hex: "8C6D2E") ?? Default.color
    static let prilDarkBlue1D3D69 = UIColor(hex: "1D3D69") ?? Default.color

    // Background
    static let prilGrayLightF6F6F6 = UIColor(hex: "F6F6F6") ?? Default.color

    // Catalog Cell
    static let prilGreenACD4AF = UIColor(hex: "ACD4AF") ?? Default.color
    static let prilPurpleB6A8CD = UIColor(hex: "B6A8CD") ?? Default.color
    static let prilLightYellowEDE38A = UIColor(hex: "EDE38A") ?? Default.color
    static let prilYellowFAC252 = UIColor(hex: "FAC252") ?? Default.color
    static let prilRedDE9494 = UIColor(hex: "DE9494") ?? Default.color
    static let prilBlue94C3DE = UIColor(hex: "94C3DE") ?? Default.color
    static let prilCyanABDDD7 = UIColor(hex: "ABDDD7") ?? Default.color
    static let prilPinkDDB1E8 = UIColor(hex: "DDB1E8") ?? Default.color

    // Font Catalog
    static let prilGreen1E4221 = UIColor(hex: "1E4221") ?? Default.color
    static let prilPurple4A3965 = UIColor(hex: "4A3965") ?? Default.color
    static let prilLightYellow847B2C = UIColor(hex: "847B2C") ?? Default.color
    static let prilYellow8E6A23 = UIColor(hex: "8E6A23") ?? Default.color
    static let prilRed653939 = UIColor(hex: "653939") ?? Default.color
    static let prilBlue261F51 = UIColor(hex: "261F51") ?? Default.color
    static let prilCyan146B56 = UIColor(hex: "146B56") ?? Default.color
    static let prilPink872E6E = UIColor(hex: "872E6E") ?? Default.color

    // MARK: - DarkMode
}

private extension UIColor {
    struct Default {
        static let color = UIColor.white
    }
}
