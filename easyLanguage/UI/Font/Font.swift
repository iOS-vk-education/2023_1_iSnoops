//
//  Font.swift
//  easyLanguage
//
//  Created by Grigoriy on 26.10.2023.
//

import UIKit

enum TextStyle {
    case header
    case bodyBig
    case bodyMedium
    case bodySmall
}

extension TextStyle {
    var font: UIFont {
        switch self {
        case .header, .bodyBig, .bodyMedium, .bodySmall:
            return UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        }
    }

    private var fontSize: CGFloat {
        switch self {
        case .header:
            return 25
        case .bodyBig:
            return 18
        case .bodyMedium:
            return 15
        case .bodySmall:
            return 12
        }
    }

    private var fontWeight: UIFont.Weight {
        switch self {
        case .header:
            return .bold
        case .bodyBig, .bodySmall, .bodyMedium:
            return .regular
        }
    }
}
