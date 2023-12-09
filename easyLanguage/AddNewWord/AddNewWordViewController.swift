//
//  AddNewWordViewController.swift
//  easyLanguage
//
//  Created by Grigoriy on 07.12.2023.
//
// Всплывающий экран для добавления нового слова

import UIKit

protocol KeyboardDismissable {
    func setDismissKeyboard()
}

protocol AddNewWordViewControllerTaps {
    func didTabAddWordButton()
}

class AddNewWordViewController: CustomViewController {
    private let nativeLabel = UILabel()
    private let nativeField: UITextField = UITextField()
    private let dividingStripView = UIView()
    private let foreignLabel = UILabel()
    private let foreignField: UITextField = UITextField()
    private let addButton: UIButton = UIButton()
}

// MARK: - Life Circle
extension AddNewWordViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        [nativeLabel, foreignLabel, nativeField, foreignField, addButton, dividingStripView].forEach {
            view.addSubview($0)
        }
        setVisualAppearance()

        setNativeLabel()
        setNativeField()
        setDividingStripView()
        setForeignLabel()
        setForeignField()
        setAddButton()
        setDismissKeyboard()
    }
}

// MARK: - private methods
private extension AddNewWordViewController {
    func setVisualAppearance() {
        setNativeAppearance()
        setDividingStripViewAppearance()
        setForeignAppearanceAppearance()
        setAddButtonAppearance()
    }

    func setNativeAppearance() {
        nativeLabel.text = TextConstants.NativeLabel.text
        nativeField.placeholder = TextConstants.NativeField.placeholderText
        nativeField.tintColor = .gray
        nativeField.borderStyle = .roundedRect
    }

    func setDividingStripViewAppearance() {
        dividingStripView.backgroundColor = .black // FIXME: - исправить после мержа
    }

    func setForeignAppearanceAppearance() {
        foreignLabel.text = TextConstants.ForeignLabel.text
        foreignField.placeholder = TextConstants.ForeignField.placeholderText
        foreignField.tintColor = .gray // FIXME: - исправить после мержа
        foreignField.borderStyle = .roundedRect
        foreignField.keyboardType = .asciiCapable
    }

    func setAddButtonAppearance() {
        addButton.setTitle(TextConstants.AddButton.title, for: .normal)
        addButton.backgroundColor = .blue // FIXME: - исправить после мержа
        addButton.layer.cornerRadius = Consts.AddButton.cornerRadius
        addButton.addTarget(self, action: #selector(didTabAddWordButton), for: .touchUpInside)
    }

    func setNativeLabel() {
        nativeLabel.translatesAutoresizingMaskIntoConstraints = false
        nativeLabel.topAnchor.constraint(equalTo: view.topAnchor,
                                         constant: UIConstants.top).isActive = true
        nativeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                         constant: view.frame.width / 10).isActive = true
        nativeLabel.widthAnchor.constraint(equalToConstant: view.frame.width / 1.5).isActive = true
        nativeLabel.sizeToFit()
    }

    func setNativeField() {
        nativeField.translatesAutoresizingMaskIntoConstraints = false
        nativeField.topAnchor.constraint(equalTo: nativeLabel.bottomAnchor,
                                         constant: UIConstants.top).isActive = true
        nativeField.heightAnchor.constraint(equalToConstant: view.frame.height / 15).isActive = true
        nativeField.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                   constant: view.frame.width / 10).isActive = true
        nativeField.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                   constant: -view.frame.width / 10).isActive = true
    }

    func setDividingStripView() {
        dividingStripView.translatesAutoresizingMaskIntoConstraints = false
        dividingStripView.topAnchor.constraint(equalTo: nativeField.bottomAnchor,
                                               constant: UIConstants.DividingStripView.top).isActive = true
        dividingStripView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                               constant: view.frame.width / 10).isActive = true
        dividingStripView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                               constant: -view.frame.width / 10).isActive = true
        dividingStripView.heightAnchor.constraint(equalToConstant:
                                               UIConstants.DividingStripView.height).isActive = true
    }

    func setForeignLabel() {
        foreignLabel.translatesAutoresizingMaskIntoConstraints = false
        foreignLabel.topAnchor.constraint(equalTo: dividingStripView.bottomAnchor,
                                          constant: UIConstants.top).isActive = true
        foreignLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                          constant: view.frame.width / 10).isActive = true
        foreignLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                          constant: -view.frame.width / 10).isActive = true
        foreignLabel.sizeToFit()
    }

    func setForeignField() {
        foreignField.translatesAutoresizingMaskIntoConstraints = false
        foreignField.topAnchor.constraint(equalTo: foreignLabel.bottomAnchor,
                                          constant: UIConstants.top).isActive = true
        foreignField.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                          constant: view.frame.width / 10).isActive = true
        foreignField.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                          constant: -view.frame.width / 10).isActive = true
        foreignField.heightAnchor.constraint(equalToConstant: view.frame.height / 15).isActive = true
    }

    func setAddButton() {
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.topAnchor.constraint(equalTo: foreignField.bottomAnchor,
                                           constant: UIConstants.AddButton.top).isActive = true
        addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                           constant: view.frame.width / 10).isActive = true
        addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                           constant: -view.frame.width / 10).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: view.frame.height / 15).isActive = true
    }
}

// MARK: - KeyboardDismissable
extension AddNewWordViewController: KeyboardDismissable {
    func setDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - AddNewWordViewControllerTaps
extension AddNewWordViewController: AddNewWordViewControllerTaps {
    @objc
    func didTabAddWordButton() {
        guard let nativeText = nativeField.text, !nativeText.isEmpty else {
            showAlert(message: "Необходимо ввести слово на русском")
            return
        }
        guard let foreignText = foreignField.text, !foreignText.isEmpty else {
            showAlert(message: "Необходимо ввести перевод слова")
            return
        }

        // работа с моделькой
        nativeField.text = nil
        foreignField.text = nil
        self.dismiss(animated: true)
    }

    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)

        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Consts
// swiftlint:disable nesting
private extension AddNewWordViewController {
    struct TextConstants {
        struct NativeLabel {
            static let text: String = "Русский"
        }

        struct ForeignLabel {
            static let text: String = "English"
        }

        struct NativeField {
            static let placeholderText: String = "Введите слово на русском"
        }

        struct ForeignField {
            static let placeholderText: String = "Enter a word in english"
        }

        struct AddButton {
            static let title: String = "Добавить слово"
        }
    }

    struct Consts {
        struct AddButton {
            static let cornerRadius: CGFloat  = 16
        }
    }

    struct UIConstants {
        static let top: CGFloat = 10.0

        struct DividingStripView {
            static let height: CGFloat = 1.0
            static let top: CGFloat = 30.0
        }

        struct AddButton {
            static let top: CGFloat = 15.0
        }
    }
}
// swiftlint:enable nesting
