//
//  Font.swift
//  easyLanguage
//
//  Created by Grigoriy on 26.10.2023.
//

import UIKit

enum TextStyle {
    case header
    case titleBig
    case titleSmall
    case bodyBig
    case bodySmall
}

extension TextStyle {
    var font: UIFont {
        switch self {
        case .header, .bodyBig, .bodySmall, .titleBig, .titleSmall:
            return UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        }
    }

    private var fontSize: CGFloat {
        switch self {
        case .header:
            return 40
        case .titleBig:
            return 25
        case .titleSmall:
            return 15
        case .bodyBig:
            return 15
        case .bodySmall:
            return 12
        }
    }

    private var fontWeight: UIFont.Weight {
        switch self {
        case .header:
            return .bold
        case .titleBig, .titleSmall:
            return .semibold
        case .bodyBig, .bodySmall:
            return .regular
        }
    }
}
