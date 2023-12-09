//
//  AddNewCategoryViewController.swift
//  easyLanguage
//
//  Created by Grigoriy on 04.12.2023.
//
// Всплывающий экран для добавления новой категории

import UIKit

protocol AddNewCategoryKeyboardDismissing {
    func setDismissKeyboard()
}

protocol AddNewCategoryTaps {
    func didTapAddCategoryButton()
    func didTapAddImage()
}

final class AddNewCategoryViewController: UIViewController, UISheetPresentationControllerDelegate {
    private let addImage: UIImageView = UIImageView()
    private let addTitle: UILabel = UILabel()
    private let newCategoryTextField: UITextField = UITextField()
    private let addCategoryButton: UIButton = UIButton()
    private var selectedImage: UIImage?
}

// MARK: - Life Circle
extension AddNewCategoryViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .PrimaryColors.Background.background
        [addImage, addTitle, newCategoryTextField, addCategoryButton].forEach {
            view.addSubview($0)
        }

        setVisualAppearance()

        setAddImage()
        setAddTitle()
        setNewCategorytextField()
        setAddCategoryButton()
        setDismissKeyboard()
    }
}

// MARK: - private methods
private extension AddNewCategoryViewController {
    func setVisualAppearance() {
        configureAddCategoryButton()
        configureNewCategoryTextField()
        configureAddImageView()
        configureAddTitleLabel()
    }

    func configureAddCategoryButton() {
        addCategoryButton.setTitle(TextConstants.AddCategoryButton.title, for: .normal)
        addCategoryButton.backgroundColor = .red  // FIXME: занести нужный цвет
        addCategoryButton.layer.cornerRadius = Constants.AddCategoryButton.cornerRadius
        addCategoryButton.addTarget(self,
                                    action: #selector(didTapAddCategoryButton),
                                    for: .touchUpInside)
    }

    func configureNewCategoryTextField() {
        newCategoryTextField.placeholder = TextConstants.NewCategoryTextField.text
        newCategoryTextField.tintColor = .gray
        newCategoryTextField.borderStyle = .roundedRect
    }

    func configureAddImageView() {
        addImage.contentMode = .scaleAspectFill
        addImage.clipsToBounds = true
        addImage.isUserInteractionEnabled = true
        addImage.image = ImageConstants.AddCategoryImageView.image
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapAddImage))
        addImage.addGestureRecognizer(tapGesture)

    }

    func configureAddTitleLabel() {
        addTitle.text = TextConstants.AddCategoryLabel.text
        addTitle.textAlignment = .center
    }

    func setAddImage() {
        addImage.translatesAutoresizingMaskIntoConstraints = false
        addImage.topAnchor.constraint(equalTo: view.topAnchor,
                                                  constant: UIConstants.AddCategoryImageView.top).isActive = true
        addImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addImage.heightAnchor.constraint(equalToConstant: view.frame.width / 4).isActive = true
        addImage.widthAnchor.constraint(equalToConstant: view.frame.width / 4).isActive = true
    }

    func setAddTitle() {
        addTitle.translatesAutoresizingMaskIntoConstraints = false
        addTitle.topAnchor.constraint(equalTo: addImage.bottomAnchor,
                                              constant: UIConstants.AddCategoryLabel.top).isActive = true
        addTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addTitle.widthAnchor.constraint(equalToConstant: view.frame.width / 2).isActive = true
        addTitle.sizeToFit()
    }

    func setNewCategorytextField() {
        newCategoryTextField.translatesAutoresizingMaskIntoConstraints = false
        newCategoryTextField.topAnchor.constraint(equalTo: addTitle.bottomAnchor,
                                                  constant: UIConstants.NewCategoryTextField.top).isActive = true
        newCategoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                  constant: view.frame.width / 10).isActive = true
        newCategoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                  constant: -view.frame.width / 10).isActive = true
        newCategoryTextField.heightAnchor.constraint(equalToConstant:
                                                  view.frame.height / 15).isActive = true
    }

    func setAddCategoryButton() {
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        addCategoryButton.topAnchor.constraint(equalTo: newCategoryTextField.bottomAnchor,
                                               constant: UIConstants.AddCategoryButton.top).isActive = true
        addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                               constant: view.frame.width / 10).isActive = true
        addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                               constant: -view.frame.width / 10).isActive = true
        addCategoryButton.heightAnchor.constraint(equalToConstant:
                                               view.frame.height / 15).isActive = true
    }
}

// MARK: - AddCategoryKeyboardDismissing
extension AddNewCategoryViewController: AddNewCategoryKeyboardDismissing {
    func setDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - AddCategoryTaps
extension AddNewCategoryViewController: AddNewCategoryTaps {
    @objc
    func didTapAddCategoryButton() {
        guard let enteredText = newCategoryTextField.text, !enteredText.isEmpty else {
            print("TextField is empty")
            // сделать проверку на существующую категорию
            // пробрасывать ошибку, если возможно
            return
        }
        newCategoryTextField.text = nil
        dismiss(animated: true)
    }

    @objc
    func didTapAddImage() {
        // отвечает за работу с ImagePicker
    }
}

// MARK: - Consts
// swiftlint:disable nesting
private extension AddNewCategoryViewController {
    struct ImageConstants {
        struct AddCategoryImageView {
            static let image: UIImage = UIImage(named: "plus-signIconImage")!
        }
    }

    struct TextConstants {
        struct AddCategoryLabel {
            static let text: String = "добавить фото"
        }

        struct NewCategoryTextField {
            static let text: String = "Название категории"
        }

        struct AddCategoryButton {
            static let title: String = "Добавить категорию"
        }
    }

    struct Constants {
        struct AddCategoryButton {
            static let cornerRadius: CGFloat = 16
        }
    }

    struct UIConstants {
        struct AddCategoryImageView {
            static let top: CGFloat = 10.0
        }

        struct AddCategoryLabel {
            static let top: CGFloat = 5.0
        }

        struct NewCategoryTextField {
            static let top: CGFloat = 20.0
        }

        struct AddCategoryButton {
            static let top: CGFloat = 10.0
        }
    }
}
// swiftlint:enable nesting
