//
//  AddNewWordViewController.swift
//  easyLanguage
//
//  Created by Grigoriy on 07.12.2023.
//
// Всплывающий экран для добавления нового слова

import UIKit

protocol AddNewWordViewControllerKeyboardDismissing {
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
    private let addWordButton: UIButton = UIButton()
}

// MARK: - Life Circle
extension AddNewWordViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        [nativeLabel, foreignLabel, nativeField, foreignField, addWordButton, dividingStripView].forEach {
            view.addSubview($0)
        }
        setVisualAppearance()

        setNativeLabel()
        setNativeField()
        setDividingStripView()
        setForeignLabel()
        setForeignField()
        setAddWordButton()
        setDismissKeyboard()
        addWordButton.addTarget(self, action: #selector(didTabAddWordButton), for: .touchUpInside)
    }
}

// MARK: - private methods
private extension AddNewWordViewController {
    func setVisualAppearance() {
        nativeLabel.text = Consts.NativeLabel.text

        nativeField.placeholder = Consts.NativeField.placeholderText

        dividingStripView.backgroundColor = .black // FIXME: - исправить после мержа с веткой ui_new

        foreignLabel.text = Consts.ForeignLabel.text
        foreignField.placeholder = Consts.ForeignField.placeholderText
        [nativeField, foreignField].forEach {
            $0.tintColor = .gray // FIXME: - исправить после мержа с веткой ui_new
            $0.borderStyle = .roundedRect
        }

        addWordButton.setTitle(Consts.AddWordButton.title, for: .normal)
        addWordButton.backgroundColor = .blue // FIXME: - исправить после мержа с веткой ui_new
        addWordButton.layer.cornerRadius = Consts.AddWordButton.cornerRadius

        foreignField.keyboardType = .asciiCapable
    }

    func setNativeLabel() {
        print(view.frame)
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

    func setAddWordButton() {
        addWordButton.translatesAutoresizingMaskIntoConstraints = false
        addWordButton.topAnchor.constraint(equalTo: foreignField.bottomAnchor,
                                           constant: UIConstants.AddWordButton.top).isActive = true
        addWordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                           constant: view.frame.width / 10).isActive = true
        addWordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                           constant: -view.frame.width / 10).isActive = true
        addWordButton.heightAnchor.constraint(equalToConstant: view.frame.height / 15).isActive = true
    }
}

extension AddNewWordViewController: AddNewWordViewControllerKeyboardDismissing {
    func setDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension AddNewWordViewController: AddNewWordViewControllerTaps {
    @objc
    func didTabAddWordButton() {
        guard let nativeText = nativeField.text, !nativeText.isEmpty else {
            print("nativeText is empty")
            // сделать проверку на существующую категорию
            // пробрасывать ошибку, если возможно (через CustomViewController)
            return
        }

        guard let foreignText = foreignField.text, !foreignText.isEmpty else {
            print("foreignText is empty")
            // сделать проверку на существующую категорию
            // пробрасывать ошибку, если возможно (через CustomViewController)
            return
        }
        // работа с моделькой
        nativeField.text = nil
        foreignField.text = nil
        self.dismiss(animated: true)
    }
}

// MARK: - Consts
// swiftlint:disable nesting
private extension AddNewWordViewController {
    struct Consts {
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
        struct AddWordButton {
            static let cornerRadius: CGFloat  = 16
            static let title: String = "Добавить слово"
        }
    }

    struct UIConstants {
        static let top: CGFloat = 10.0

        struct DividingStripView {
            static let height: CGFloat = 1.0
            static let top: CGFloat = 30.0
        }

        struct AddWordButton {
            static let top: CGFloat = 15.0
        }
    }
}
// swiftlint:enable nesting
