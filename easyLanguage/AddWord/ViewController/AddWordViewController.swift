//
//  AddNewWordViewController.swift
//  easyLanguage
//
//  Created by Grigoriy on 07.12.2023.
//
// Всплывающий экран для добавления нового слова

import UIKit

protocol AddWordOutput: AnyObject {
    func didCreateWord(with categoryId: String)
    func isWordExist(with uiModel: WordUIModel) -> Bool
}

final class AddWordViewController: UIViewController {
    private let categoryID: String
    var output: AddWordViewOutput?
    weak var delegate: AddWordOutput?

    // MARK: - native block

    let translate = {
        let imageView = UIImageView(image: UIImage(named: "Translate"))
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    let nativeLabel = {
        let label = UILabel()
        label.text = "Русский"
        return label
    }()

    let nativeField = {
        let field = UITextField()
        field.placeholder = "Введите слово на русском"
        field.tintColor = .gray
        field.borderStyle = .roundedRect
        return field
    }()

    let dividerView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()

    // MARK: - foreign block

    let foreignLabel = {
        let label = UILabel()
        label.text = "English"
        return label
    }()

    let foreignField = {
        let field = UITextField()
        field.placeholder = "Enter a word in english"
        field.tintColor = .gray
        field.borderStyle = .roundedRect
        field.keyboardType = .asciiCapable
        return field
    }()

    let addWordButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("addWord", comment: ""), for: .normal)
        button.backgroundColor = .PrimaryColors.Button.blue
        button.layer.cornerRadius = 16
        return button
    }()

    lazy var padding = { view.bounds.width / 10 }()
    lazy var height = { view.bounds.height / 15 }()

    // MARK: - init

    init(categoryID: String) {
        self.categoryID = categoryID
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - life cycle
extension AddWordViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.handle(event: .viewLoaded)
    }
}

// MARK: - AddNewWordViewInput

extension AddWordViewController: AddWordViewInput {
    func handle(event: AddWordViewInputEvent) {
        switch event {
        case .showView:
            view.backgroundColor = .PrimaryColors.Background.background
            setConstraints()
            setEvents()
        case .updateField((word: let word, native: let native)):
            native ? (foreignField.text = word) : (nativeField.text = word)
        case .showAlert(message: let message):
            showAlert(message: message)
        case .updateCategoryDetail(id: let id):
            delegate?.didCreateWord(with: id)
            clearFields()
            self.dismiss(animated: true)
        }
    }
}

// MARK: - events

extension AddWordViewController {
    func setEvents() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        translate.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapTranslate)))
        addWordButton.addTarget(self, action: #selector(didTabButton), for: .touchUpInside)
    }
}

private extension AddWordViewController {
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc
    func didTapTranslate() {
        @Trimmed var native = nativeField.text!
        @Trimmed var foreign = foreignField.text!
        output?.handle(event: .translateButtonTapped(native: native, foreign: foreign))
    }

    @objc
    func didTabButton() {
        @Trimmed var native = nativeField.text!
        @Trimmed var foreign = foreignField.text!

        let uiModel = WordUIModel(
            categoryId: categoryID,
            translations: ["ru": native, "en": foreign],
            isLearned: false,
            swipesCounter: 0,
            id: UUID().uuidString
        )

        guard let isWordExist = delegate?.isWordExist(with: uiModel), !isWordExist else {
            showAlert(message: NSLocalizedString("wordAlreadyExistAlert", comment: ""))
            return
        }

        output?.handle(event: .addButtonTapped(
            uiModel: uiModel
        ))
    }

    func clearFields() {
        nativeField.text = nil
        foreignField.text = nil
    }
}

// MARK: - Alert

private extension AddWordViewController {
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)

        self.present(alertController, animated: true)
    }
}
