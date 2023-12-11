//
//  Color + extensions.swift
//  easyLanguage
//
//  Created by Grigoriy on 02.11.2023.
//

import UIKit

extension UIColor {
    /// init, использующий hex цвета
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    /// генерирует случайный цвет, подобный заданному базовому цвету,
    /// с некоторыми случайными вариациями в тоне и прозрачности
    static func generateRandomSimilarColor(from baseColor: UIColor,
                                           withToneVariation toneVariation: CGFloat = 0.15,
                                           alphaVariation: CGFloat = 0.15) -> UIColor {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0

        baseColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        // Generate random variations within the specified range
        let randomToneVariation = CGFloat.random(in: -toneVariation...toneVariation)
        let randomAlphaVariation = CGFloat.random(in: -alphaVariation...alphaVariation)

        // Apply random variations to the original color components
        let modifiedRed = min(1.0, max(0.0, red + randomToneVariation))
        let modifiedGreen = min(1.0, max(0.0, green + randomToneVariation))
        let modifiedBlue = min(1.0, max(0.0, blue + randomToneVariation))

        // Apply random variation to alpha
        let modifiedAlpha = min(1.0, max(0.0, alpha + randomAlphaVariation))

        return UIColor(red: modifiedRed, green: modifiedGreen, blue: modifiedBlue, alpha: modifiedAlpha)
    }

}
