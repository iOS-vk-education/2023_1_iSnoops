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
            static let background: UIColor = AppColor(lightMode: UIColor(hex: "F6F6F6") ?? white,
                                                   darkMode: UIColor(hex: "26282B") ?? .darkGray).currentColor
        }

        struct Button {
            static let blue: UIColor = AppColor(lightMode: UIColor(hex: "3478F6") ?? .white).currentColor
        }
        struct Font {
            static let header: UIColor = AppColor(lightMode: .black, darkMode: .white).currentColor
            static let secondary: UIColor = AppColor(lightMode: .gray).currentColor
        }
        struct TextField {
            static let fieldColor: UIColor = AppColor(lightMode: UIColor(hex: "F6F6F6") ?? .white,
                                                      darkMode: UIColor(hex: "282829") ?? .darkGray).currentColor
        }
    }

    struct Profile {
        struct ButtonLabel {
            static let color: UIColor = AppColor(lightMode: UIColor(hex: "000000") ?? white,
                                                   darkMode: UIColor(hex: "FFFFFF") ?? .darkGray).currentColor
        }
    }

    struct SecondaryColors {
        struct ProgressView {
            static let gray: UIColor = AppColor(lightMode: UIColor(hex: "D9D9D9") ?? .white).currentColor
            static let green: UIColor = AppColor(lightMode: UIColor(hex: "6CDC72") ?? .white).currentColor
        }
    }

    struct Catalog {
        struct Pink {
            static let topFiveBackground: UIColor = AppColor(lightMode: UIColor(hex: "E3A8BE") ?? .white).currentColor
            static let topFiveBackText: UIColor = AppColor(lightMode: UIColor(hex: "713D4F") ?? .white).currentColor
            static let categoryBackground: UIColor = AppColor(lightMode: UIColor(hex: "DDB1E8") ?? .white).currentColor
            static let categoryText: UIColor = AppColor(lightMode: UIColor(hex: "872E6E") ?? .white).currentColor
        }

        struct Yellow {
            static let topFiveBackground: UIColor = AppColor(lightMode: UIColor(hex: "F8DDA8") ?? .white).currentColor
            static let topFiveBackText: UIColor = AppColor(lightMode: UIColor(hex: "8C6D2E") ?? .white).currentColor
            static let categoryBackground: UIColor = AppColor(lightMode: UIColor(hex: "FAC252") ?? .white,
                                                           darkMode: UIColor(hex: "D0A145") ?? .darkGray).currentColor
            static let categoryText: UIColor = AppColor(lightMode: UIColor(hex: "8E6A23") ?? .white).currentColor
        }

        struct Blue {
            static let topFiveBackground: UIColor = AppColor(lightMode: UIColor(hex: "ADC0DB") ?? .white).currentColor
            static let topFiveBackText: UIColor = AppColor(lightMode: UIColor(hex: "1D3D69") ?? .white).currentColor
            static let categoryBackground: UIColor = AppColor(lightMode: UIColor(hex: "94C3DE") ?? .white).currentColor
            static let categoryText: UIColor = AppColor(lightMode: UIColor(hex: "261F51") ?? .white).currentColor
        }

        struct Green {
            static let categoryBackground: UIColor = AppColor(lightMode: UIColor(hex: "ACD4AF") ?? .white,
                                                           darkMode: UIColor(hex: "68A36D") ?? .darkGray).currentColor
            static let categoryText: UIColor = AppColor(lightMode: UIColor(hex: "1E4221") ?? .white).currentColor
        }

        struct Purple {
            static let categoryBackground: UIColor = AppColor(lightMode: UIColor(hex: "B6A8CD") ?? .white,
                                                           darkMode: UIColor(hex: "796C8F") ?? .darkGray).currentColor
            static let categoryText: UIColor = AppColor(lightMode: UIColor(hex: "4A3965") ?? .white).currentColor
        }

        struct LightYellow {
            static let categoryBackground: UIColor = AppColor(lightMode: UIColor(hex: "EDE38A") ?? .white,
                                                           darkMode: UIColor(hex: "D6C954") ?? .darkGray).currentColor
            static let categoryText: UIColor = AppColor(lightMode: UIColor(hex: "847B2C") ?? .white).currentColor
        }

        struct Cyan {
            static let categoryBackground: UIColor = AppColor(lightMode: UIColor(hex: "ABDDD7") ?? .white,
                                                           darkMode: UIColor(hex: "D0A145") ?? .darkGray).currentColor
            static let categoryText: UIColor = AppColor(lightMode: UIColor(hex: "146B56") ?? .white).currentColor
        }

        struct Red {
            static let categoryBackground: UIColor = AppColor(lightMode: UIColor(hex: "DE9494") ?? .white).currentColor
            static let categoryText: UIColor = AppColor(lightMode: UIColor(hex: "653939") ?? .white).currentColor
        }
    }
}
// swiftlint:enable nesting
