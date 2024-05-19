//
//  Color.swift
//  easyLanguage
//
//  Created by Grigoriy on 25.10.2023.
//

import UIKit
/// Структура для управления цветами в различных режимах (светлый, темный, авто).
struct AppColor {
    enum SystemMode: CaseIterable {
        case lightMode
        case autoMode
        case darkMode

        func description() -> String {
            switch self {
            case .lightMode:
                NSLocalizedString("lightThemeLabel", comment: "")
            case .autoMode:
                NSLocalizedString("autoThemeLabel", comment: "")
            case .darkMode:
                NSLocalizedString("darkThemeLabel", comment: "")
            }
        }
    }

    private let lightMode: UIColor
    private let darkMode: UIColor

    init(lightMode: UIColor, darkMode: UIColor? = nil) {
        self.lightMode = lightMode
        self.darkMode = darkMode ?? lightMode
    }

    var currentColor: UIColor {
        return makeCurrentColor()
    }

    static var systemMode: SystemMode = .autoMode {
        didSet {
            var userInterfaceStyle: UIUserInterfaceStyle {
                switch AppColor.systemMode {
                case .lightMode: return .light
                case .darkMode: return .dark
                case .autoMode: return .unspecified
                }
            }

            guard #available(iOS 13.0, *) else { return }
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.forEach { $0.overrideUserInterfaceStyle = userInterfaceStyle }
            }

        }
    }
    // swiftlint:disable all
    //Когда система iOS обнаруживает изменение темы пользовательского интерфейса (например, изменение между светлой и темной темой), она автоматически обновляет traitCollection для всех компонентов пользовательского интерфейса Когда traitCollection изменяется, система оповещает всех слушателей, включая данное замыкание, чтобы они могли обновиться в соответствии с новой темой.
    // swiftlint:enable all
    private func makeCurrentColor() -> UIColor {
        return UIColor { traitCollection in
            switch AppColor.systemMode {
            case .lightMode:
                return lightMode
            case .darkMode:
                return darkMode
            case .autoMode:
                return traitCollection.userInterfaceStyle == .light ? lightMode : darkMode
            }
        }
    }
}
