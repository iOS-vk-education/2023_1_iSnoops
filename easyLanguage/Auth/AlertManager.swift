//
//  AlertManager.swift
//  easyLanguage
//
//  Created by Матвей Матюшко on 27.12.2023.
//

import Foundation
import UIKit

class AlertManager {
    private static func showBasicAlert(on viewController: UIViewController, title: String, message: String?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Назад", style: .default, handler: nil))
            viewController.present(alert, animated: true)
        }
    }
}

// MARK: - Недействительные данные
extension AlertManager {
    public static func showInvalidEmailAlert(on viewController: UIViewController) {
        self.showBasicAlert(on: viewController,
                            title: "Недействительный email",
                            message: "Пожалуйста, проверьте введенные данные")
    }

    public static func showInvalidPasswordAlert(on viewController: UIViewController) {
        self.showBasicAlert(on: viewController,
                            title: "Недействительный пароль",
                            message: "Пожалуйста, проверьте введенные данные")
    }

    public static func showInvalidUsernameAlert(on viewController: UIViewController) {
        self.showBasicAlert(on: viewController,
                            title: "Недействительный имя пользователя",
                            message: "Пожалуйста, проверьте введенные данные")
    }
}

// MARK: - Ошибки при регистрации
extension AlertManager {
    public static func showWeakPassword(on viewController: UIViewController) {
        self.showBasicAlert(on: viewController, title: "Слабый пароль", message: nil)
    }

    public static func showEmailAlreadyInUse(on viewController: UIViewController) {
        self.showBasicAlert(on: viewController, title: "Эта почта уже используется", message: nil)
    }
    public static func showRegistrationErrorAlert(on viewController: UIViewController) {
        self.showBasicAlert(on: viewController, title: "Неизвестная ошибка при регистрации", message: nil)
    }
}

// MARK: - Ошибки при входе
extension AlertManager {
    public static func showSignInErrorAlert(on viewController: UIViewController) {
        self.showBasicAlert(on: viewController, title: "Не удалось войти в аккаунт", message: nil)
    }

    public static func showSignInErrorAlert(on viewController: UIViewController, with error: Error) {
        self.showBasicAlert(on: viewController,
                            title: "Не удалось войти в аккаунт",
                            message: "\(error.localizedDescription)")
    }
}
