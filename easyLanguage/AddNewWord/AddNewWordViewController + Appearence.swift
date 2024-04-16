//
//  AddNewWordViewController + Appearence.swift
//  easyLanguage
//
//  Created by Grigoriy on 16.04.2024.
//

import UIKit

// MARK: - set appearance elements
extension AddNewWordViewController {
    func setAppearance() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        view.backgroundColor = .PrimaryColors.Background.background

        setNativeLabelAppearance()
        setTranslateButtonAppearance()
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

    func setTranslateButtonAppearance() {
        translate.image = UIImage(named: "Translate")
        translate.contentMode = .scaleAspectFit

        translate.isUserInteractionEnabled = true
        translate.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                              action: #selector(didTapTranslate)))
    }

    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc
    func didTapTranslate() {
        @Trimmed var nativeText: String = nativeField.text ?? ""
        @Trimmed var foreignText: String = foreignField.text ?? ""

        output?.handle(event: .translateButtonTapped(nativeText: nativeText, foreignText: foreignText))
    }

    @objc
    func didTabButton() {
        @Trimmed var nativeText: String = nativeField.text ?? ""
        @Trimmed var foreignText: String = foreignField.text ?? ""

        let translations: [String: String] = ["ru": nativeText, "en": foreignText]

        output?.handle(event: .addNewCardTapped(wordUIModel: WordUIModel(categoryId: categoryId,
                                                                         translations: translations,
                                                                         isLearned: false,
                                                                         id: UUID().uuidString)))
    }
}

// MARK: - set constraints
extension AddNewWordViewController {
    func addConstraints() {
        [nativeLabel, translate, foreignLabel, nativeField, foreignField, button, dividingStripView].forEach {
            view.addSubview($0)
        }

        horizontalPadding = view.bounds.width / 10
        height =  view.bounds.height / 15

        setNativeLabel()
        setTranslate()
        setNativeField()
        setDividingStripView()
        setForeignLabel()
        setForeignField()
        setButton()
    }

    func setNativeLabel() {
        nativeLabel.translatesAutoresizingMaskIntoConstraints = false
        nativeLabel.topAnchor.constraint(equalTo: view.topAnchor,
                                         constant: view.bounds.height / 15).isActive = true
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

    func setTranslate() {
        translate.translatesAutoresizingMaskIntoConstraints = false
        translate.bottomAnchor.constraint(equalTo: nativeField.topAnchor,
                                          constant: -UIConstants.top).isActive = true
        translate.widthAnchor.constraint(equalToConstant: view.bounds.width / 10).isActive = true
        translate.heightAnchor.constraint(equalToConstant: view.bounds.width / 10).isActive = true
        translate.trailingAnchor.constraint(equalTo: view.trailingAnchor,
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
