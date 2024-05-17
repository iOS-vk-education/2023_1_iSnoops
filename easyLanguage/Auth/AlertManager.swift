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
            alert.addAction(UIAlertAction(title: NSLocalizedString("alertButton", comment: ""),
                                          style: .default,
                                          handler: nil))
            viewController.present(alert, animated: true)
        }
    }
}

/// универсальный метод показа алерта без локализации!
extension AlertManager {
    public static func showAlert(
        on viewController: UIViewController,
        title: String?,
        message: String?
    ) {
        showBasicAlert(on: viewController,
                       title: NSLocalizedString(title ?? "", comment: ""),
                       message: nil)
    }
}

// MARK: - Недействительные данные
extension AlertManager {
    public static func showInvalidEmailAlert(on viewController: UIViewController) {
        self.showBasicAlert(on: viewController,
                            title: NSLocalizedString("invalidEmailTitle", comment: ""),
                            message: NSLocalizedString("invalidMessage", comment: ""))
    }

    public static func showInvalidPasswordAlert(on viewController: UIViewController) {
        self.showBasicAlert(on: viewController,
                            title: NSLocalizedString("invalidPasswordTitle", comment: ""),
                            message: NSLocalizedString("invalidMessage", comment: ""))
    }

    public static func showInvalidUsernameAlert(on viewController: UIViewController) {
        self.showBasicAlert(on: viewController,
                            title: NSLocalizedString("invalidNameTitle", comment: ""),
                            message: NSLocalizedString("invalidMessage", comment: ""))
    }
}

// MARK: - Ошибки при регистрации
extension AlertManager {
    public static func showWeakPassword(on viewController: UIViewController) {
        self.showBasicAlert(on: viewController, title: NSLocalizedString("weakPassword", comment: ""), message: nil)
    }
    public static func showEmailAlreadyInUse(on viewController: UIViewController) {
    self.showBasicAlert(on: viewController,
                            title: NSLocalizedString("emailAlreadyInUse", comment: ""),
                            message: nil)
    }
    public static func showRegistrationErrorAlert(on viewController: UIViewController) {
    self.showBasicAlert(on: viewController,
                            title: NSLocalizedString("registrationErrorAlert", comment: ""),
                            message: nil)
    }
}

// MARK: - Ошибки при входе
extension AlertManager {
    public static func showSignInErrorAlert(on viewController: UIViewController) {
        self.showBasicAlert(on: viewController, title: NSLocalizedString("signInErrorAlert", comment: ""), message: nil)
    }

    public static func showSignInErrorAlert(on viewController: UIViewController, with error: Error) {
        self.showBasicAlert(on: viewController,
                            title: NSLocalizedString("signInErrorAlert", comment: ""),
                            message: "\(error.localizedDescription)")
    }
}

// MARK: - Ошибки при загрузке данных
extension AlertManager {
    public static func showDataLoadErrorAlert(on viewController: UIViewController) {
        self.showBasicAlert(on: viewController, title: NSLocalizedString("dataLoadErrorAlert", comment: ""),
                            message: nil)
    }

    public static func showWordDeleteAlert(on viewController: UIViewController) {
        self.showBasicAlert(on: viewController, title: NSLocalizedString("wordDeleteAlert", comment: ""), message: nil)
    }
}

// MARK: - Ошибки при добавлении новой категории
extension AlertManager {
    public static func showAddNewCategoryAlert(on viewController: UIViewController) {
        self.showBasicAlert(on: viewController,
                            title: NSLocalizedString("addNewCategoryAlert", comment: ""),
                            message: nil)
    }
}

// MARK: - Ошибки обноваления констраинтов
extension AlertManager {
    public static func showReloadHeightAlert(on viewController: UIViewController) {
        self.showBasicAlert(on: viewController,
                            title: NSLocalizedString("reloadHeightAlert", comment: ""),
                            message: nil)
    }
}

// MARK: - Ошибки на экране обучениия
extension AlertManager {
    public static func showEmptyLearningModel(on viewController: UIViewController) {
        self.showBasicAlert(on: viewController,
                            title: NSLocalizedString("dataPostErrorAlert", comment: ""),
                            message: nil)
    }
}
