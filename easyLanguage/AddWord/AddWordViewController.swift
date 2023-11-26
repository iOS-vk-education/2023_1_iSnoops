//
//  AddWordViewController.swift
//  easyLanguage
//
//  Created by Grigoriy on 22.11.2023.
//

import UIKit

class AddWordViewController: CustomViewController {
    private let visualBar = UIView()
    private let nativeLabel = UILabel()
    private let nativeField: UITextField = UITextField()
    private let dividingStripView = UIView()
    private let foreignLabel = UILabel()
    private let foreignField: UITextField = UITextField()
    private let addWordButton: UIButton = UIButton()
    weak var delegate: AddNewWordDelegate?
    private var linkedWordsId: String = ""

    init(delegate: AddNewWordDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Circle
extension AddWordViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        [visualBar, nativeLabel, foreignLabel, nativeField, foreignField, addWordButton, dividingStripView].forEach {
            view.addSubview($0)
        }
        setVisualAppearance()

        setVisualBar()
        setNativeLabel()
        setNativeField()
        setDividingStripView()
        setForeignLabel()
        setForeignField()
        setAddWordButton()
        setDismissKeyboard()
        addWordButton.addTarget(self, action: #selector(didTabButton), for: .touchUpInside)
    }
}

// MARK: - methods
extension AddWordViewController {
    func setLinkedWordsId(with linkedWordsId: String) {
        self.linkedWordsId = linkedWordsId
    }
}

// MARK: - private methods
private extension AddWordViewController {
    @objc
    func didTabButton() {
        guard let nativeText = nativeField.text, !nativeText.isEmpty else {
            print("TextField is empty")
            // сделать проверку на существующую категорию
            // пробрасывать ошибку, если возможно
            return
        }

        guard let foreignText = foreignField.text, !foreignText.isEmpty else {
            print("TextField is empty")
            // сделать проверку на существующую категорию
            // пробрасывать ошибку, если возможно
            return
        }

        delegate?.createWord(with: WordModel(wordId: nil,
                                             linkedWordsId: linkedWordsId,
                                             words: ["ru": nativeText, "en": foreignText],
                                             isLearned: false,
                                             createdDate: Date()))

        nativeField.text = nil
        foreignField.text = nil
        self.dismiss(animated: true)
    }

    func setDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func setVisualAppearance() {
        visualBar.layer.cornerRadius = 4
        visualBar.backgroundColor = .gray

        nativeLabel.text = Consts.NativeLabel.text

        nativeField.placeholder = Consts.NativeField.placeholderText

        dividingStripView.backgroundColor = .black

        foreignLabel.text = Consts.ForeignLabel.text

        foreignField.placeholder = Consts.ForeignField.placeholderText
        [nativeField, foreignField].forEach {
            $0.tintColor = .gray
            $0.borderStyle = .roundedRect
        }

        addWordButton.setTitle(Consts.AddWordButton.title, for: .normal)
        addWordButton.backgroundColor = .PrimaryColors.Button.blue
        addWordButton.layer.cornerRadius = 16

        foreignField.keyboardType = .asciiCapable
    }

    func setVisualBar() {
        visualBar.translatesAutoresizingMaskIntoConstraints = false
        visualBar.topAnchor.constraint(equalTo: view.topAnchor,
                                       constant: UIConstants.VisualBar.top).isActive = true
        visualBar.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                       constant: view.frame.width / 2 - 31).isActive = true
        visualBar.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                       constant: -view.frame.width / 2 + 31).isActive = true
        visualBar.heightAnchor.constraint(equalToConstant: UIConstants.VisualBar.height).isActive = true
    }

    func setNativeLabel() {
        nativeLabel.translatesAutoresizingMaskIntoConstraints = false
        nativeLabel.topAnchor.constraint(equalTo: visualBar.bottomAnchor,
                                         constant: view.frame.width / 25).isActive = true
        nativeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                         constant: view.frame.width / 10.6).isActive = true
        nativeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                         constant: -view.frame.width / 10.6).isActive = true
        nativeLabel.sizeToFit()
    }

    func setNativeField() {
        nativeField.translatesAutoresizingMaskIntoConstraints = false
        nativeField.topAnchor.constraint(equalTo: nativeLabel.bottomAnchor,
                                         constant: view.frame.width / 14.5).isActive = true
        nativeField.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                         constant: view.frame.width / 10.6).isActive = true
        nativeField.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                         constant: -view.frame.width / 10.6).isActive = true
        nativeField.heightAnchor.constraint(equalToConstant: view.frame.height / 17.3).isActive = true
    }

    func setDividingStripView() {
        dividingStripView.translatesAutoresizingMaskIntoConstraints = false
        dividingStripView.topAnchor.constraint(equalTo: nativeField.bottomAnchor,
                                               constant: view.frame.height / 12.7).isActive = true
        dividingStripView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                               constant: view.frame.width / 10.6).isActive = true
        dividingStripView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                               constant: -view.frame.width / 10.6).isActive = true
        dividingStripView.heightAnchor.constraint(equalToConstant:
                                               UIConstants.DividingStripView.height).isActive = true
    }

    func setForeignLabel() {
        foreignLabel.translatesAutoresizingMaskIntoConstraints = false
        foreignLabel.topAnchor.constraint(equalTo: dividingStripView.bottomAnchor,
                                          constant: view.frame.height / 50.1).isActive = true
        foreignLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                          constant: view.frame.width / 10.6).isActive = true
        foreignLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                          constant: -view.frame.width / 10.6).isActive = true
        foreignLabel.sizeToFit()
    }

    func setForeignField() {
        foreignField.translatesAutoresizingMaskIntoConstraints = false
        foreignField.topAnchor.constraint(equalTo: foreignLabel.bottomAnchor,
                                          constant: view.frame.width / 14.5).isActive = true
        foreignField.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                          constant: view.frame.width / 10.6).isActive = true
        foreignField.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                          constant: -view.frame.width / 10.6).isActive = true
        foreignField.heightAnchor.constraint(equalToConstant: view.frame.height / 17.3).isActive = true
    }

    func setAddWordButton() {
        addWordButton.translatesAutoresizingMaskIntoConstraints = false
        addWordButton.topAnchor.constraint(equalTo: foreignField.bottomAnchor,
                                           constant: view.frame.height / 23).isActive = true
        addWordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                           constant: view.frame.width / 10.6).isActive = true
        addWordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                           constant: -view.frame.width / 10.6).isActive = true
        addWordButton.heightAnchor.constraint(equalToConstant: view.frame.height / 14.2).isActive = true
    }
}

// MARK: - Consts
// swiftlint:disable nesting
private extension AddWordViewController {
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
            static let title: String = "Добавить слово"
        }
    }

    struct UIConstants {
        struct VisualBar {
            static let top: CGFloat = 10.0
            static let height: CGFloat = 8.0
        }
        struct DividingStripView {
            static let height: CGFloat = 1.0
        }
    }
}
// swiftlint:enable nesting
