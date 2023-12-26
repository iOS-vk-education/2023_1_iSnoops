//
//  AddNewWordViewController.swift
//  easyLanguage
//
//  Created by Grigoriy on 07.12.2023.
//
// Всплывающий экран для добавления нового слова

import UIKit

protocol AddNewWordOutput {
    func didTabButton()
}

class AddNewWordViewController: UIViewController {
    private let nativeLabel = UILabel()
    private let nativeField: UITextField = UITextField()
    private let dividingStripView = UIView()
    private let foreignLabel = UILabel()
    private let foreignField: UITextField = UITextField()
    private let button: UIButton = UIButton()
    private var horizontalPadding: CGFloat = 0
    private var height: CGFloat = 0
}

// MARK: - life cycle
extension AddNewWordViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .PrimaryColors.Background.background
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)

        setAppearance()
        addConstraints()
    }

    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - set appearance elements
private extension AddNewWordViewController {
    func setAppearance() {
        setNativeLabelAppearance()
        setNativeFieldAppearance()
        setDividingStripViewAppearance()
        setForeignLabelAppearance()
        setForeignFieldAppearance()
        setButtonAppearance()
    }

    func setNativeLabelAppearance() {
        nativeLabel.text = "Русский"
    }

    func setNativeFieldAppearance() {
        nativeField.placeholder = "Введите слово на русском"
        nativeField.tintColor = .gray
        nativeField.borderStyle = .roundedRect
    }

    func setDividingStripViewAppearance() {
        dividingStripView.backgroundColor = .black
    }

    func setForeignLabelAppearance() {
        foreignLabel.text = "English"
    }

    func setForeignFieldAppearance() {
        foreignField.placeholder = "Enter a word in english"
        foreignField.tintColor = .gray
        foreignField.borderStyle = .roundedRect
        foreignField.keyboardType = .asciiCapable
    }

    func setButtonAppearance() {
        button.setTitle("Добавить слово", for: .normal)
        button.backgroundColor = .PrimaryColors.Button.blue
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTabButton), for: .touchUpInside)
    }
}

// MARK: - set constraints
private extension AddNewWordViewController {
    func addConstraints() {
        [nativeLabel, foreignLabel, nativeField, foreignField, button, dividingStripView].forEach {
            view.addSubview($0)
        }

        horizontalPadding = view.bounds.width / 10
        height =  view.bounds.height / 15

        setNativeLabel()
        setNativeField()
        setDividingStripView()
        setForeignLabel()
        setForeignField()
        setButton()
    }

    func setNativeLabel() {
        nativeLabel.translatesAutoresizingMaskIntoConstraints = false
        nativeLabel.topAnchor.constraint(equalTo: view.topAnchor,
                                         constant: UIConstants.top).isActive = true
        nativeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                         constant: horizontalPadding).isActive = true
        nativeLabel.widthAnchor.constraint(equalToConstant: view.bounds.width / 1.5).isActive = true
        nativeLabel.sizeToFit()
    }

    func setNativeField() {
        nativeField.translatesAutoresizingMaskIntoConstraints = false
        nativeField.topAnchor.constraint(equalTo: nativeLabel.bottomAnchor,
                                         constant: UIConstants.top).isActive = true
        nativeField.heightAnchor.constraint(equalToConstant: height).isActive = true
        nativeField.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                             constant: horizontalPadding).isActive = true
        nativeField.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                              constant: -horizontalPadding).isActive = true
    }

    func setDividingStripView() {
        dividingStripView.translatesAutoresizingMaskIntoConstraints = false
        dividingStripView.topAnchor.constraint(equalTo: nativeField.bottomAnchor, constant: 30).isActive = true
        dividingStripView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                   constant: horizontalPadding).isActive = true
        dividingStripView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                    constant: -horizontalPadding).isActive = true
        dividingStripView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }

    func setForeignLabel() {
        foreignLabel.translatesAutoresizingMaskIntoConstraints = false
        foreignLabel.topAnchor.constraint(equalTo: dividingStripView.bottomAnchor,
                                          constant: UIConstants.top).isActive = true
        foreignLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                              constant: horizontalPadding).isActive = true
        foreignLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                               constant: -horizontalPadding).isActive = true
        foreignLabel.sizeToFit()
    }

    func setForeignField() {
        foreignField.translatesAutoresizingMaskIntoConstraints = false
        foreignField.topAnchor.constraint(equalTo: foreignLabel.bottomAnchor,
                                          constant: UIConstants.top).isActive = true
        foreignField.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                              constant: horizontalPadding).isActive = true
        foreignField.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                               constant: -horizontalPadding).isActive = true
        foreignField.heightAnchor.constraint(equalToConstant: height).isActive = true
    }

    func setButton() {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: foreignField.bottomAnchor, constant: 15).isActive = true
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                        constant: horizontalPadding).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                         constant: -horizontalPadding).isActive = true
        button.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}

// MARK: - Constants
private extension AddNewWordViewController {
    struct UIConstants {
        static let top: CGFloat = 10
    }
}

// MARK: - AddNewWordOutput
extension AddNewWordViewController: AddNewWordOutput {
    @objc
    func didTabButton() {
        guard let nativeText = nativeField.text, !nativeText.isEmpty else {
            showAlert(message: "Необходимо ввести слово на русском")
            return
        }
        guard let foreignText = foreignField.text, !foreignText.isEmpty else {
            showAlert(message: "Необходимо ввести перевод слова")
            return
        }

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
