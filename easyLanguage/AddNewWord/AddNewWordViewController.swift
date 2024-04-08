//
//  AddNewWordViewController.swift
//  easyLanguage
//
//  Created by Grigoriy on 07.12.2023.
//
// Всплывающий экран для добавления нового слова

import UIKit

protocol AddNewWordViewOutput {
    func handle(event: AddNewWordViewEvent)
}

protocol AddNewWordOutput: AnyObject {
    func didCreateWord(with categoryId: String)
}

class AddNewWordViewController: UIViewController {
    var output: AddNewWordViewOutput?

    var categoryId = ""

    private let nativeLabel = UILabel()
    private let translate = UIImageView()
    private let nativeField: UITextField = UITextField()
    private let dividingStripView = UIView()
    private let foreignLabel = UILabel()
    private let foreignField: UITextField = UITextField()
    private let button: UIButton = UIButton()
    private var horizontalPadding: CGFloat = 0
    private var height: CGFloat = 0

    weak var delegate: AddNewWordOutput?
}

// MARK: - life cycle
extension AddNewWordViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        output?.handle(event: .viewLoaded)
    }

    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension AddNewWordViewController: AddNewWordPresenterOutput {
    func handle(event: AddNewWordPresenterEvent) {
        switch event {
        case .showView:
            setAppearance()
            addConstraints()
        case .showError(error: let error):
            DispatchQueue.main.async {
                self.showAlert(message: error)
            }
        case .updateNativeField(text: let text):
            DispatchQueue.main.async {
                self.nativeField.text = text
            }
        case .updateForeignField(text: let text):
            DispatchQueue.main.async {
                self.foreignField.text = text
            }
        case .updateCategoryDetail(id: let id):
            delegate?.didCreateWord(with: id)
        }
    }
}

// MARK: - set appearance elements
private extension AddNewWordViewController {
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

    @objc
    func didTapTranslate() {
        @Trimmed var nativeText: String? = nativeField.text
        @Trimmed var foreignText: String? = foreignField.text

        output?.handle(event: .translateCheckIsOptionText(nativeText, foreignText))
//TODO: - убрать
        let search: String
        let isNative: Bool

        if nativeText != nil && !nativeText!.isEmpty {
            search = nativeText!
            isNative = true
        } else {
            search = foreignText!
            isNative = false
        }
        output?.handle(event: .translateButtonTapped(word: search, isNative: isNative))
    }

    func setTranslateButtonAppearance() {
        translate.image = UIImage(named: "Translate")
        translate.contentMode = .scaleAspectFit

        translate.isUserInteractionEnabled = true
        translate.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                              action: #selector(didTapTranslate)))
    }

    @objc
    func didTabButton() {
        @Trimmed var nativeText: String? = nativeField.text
        @Trimmed var foreignText: String? = foreignField.text

//TODO: - убрать
        guard let nativeText = nativeText, !nativeText.isEmpty else {
            showAlert(message: "Необходимо ввести слово на русском")
            return
        }

        guard let foreignText = foreignText, !foreignText.isEmpty else {
            showAlert(message: "Необходимо ввести перевод слова")
            return
        }

        let translations: [String: String] = ["ru": nativeText, "en": foreignText]

        output?.handle(event: .addNewCardTapped(wordUIModel: WordUIModel(categoryId: categoryId,
                                                                         translations: translations,
                                                                         isLearned: false,
                                                                         id: UUID().uuidString)))
        nativeField.text = nil
        foreignField.text = nil
        self.dismiss(animated: true)
    }
}

// MARK: - Alert
private extension AddNewWordViewController {
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)

        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - set constraints
private extension AddNewWordViewController {
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
