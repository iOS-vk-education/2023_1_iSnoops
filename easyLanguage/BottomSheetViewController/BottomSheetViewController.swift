//
//  BottomSheetViewController.swift
//  CustomBottomSheet
//
//  Created by Grigoriy on 19.11.2023.
//

import UIKit

class BottomSheetViewController: CustomViewController {
    private let addCategoryView = AddCategoryView()
    private let textField: UITextField = UITextField()
    private let addCategoryButton: UIButton = UIButton()
    private let imagePicker = ImagePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        [addCategoryView, addCategoryButton, textField].forEach {
            view.addSubview($0)
        }
        setVisualAppearance()
        setTextField()
        setAddCategoryButton()
        setAddCategoryView()

        addCategoryView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapAddCategoryView))
        addCategoryView.addGestureRecognizer(tapGesture)
        addCategoryButton.addTarget(self, action: #selector(didTapAddCategoryButton), for: .touchUpInside)
    }
}

private extension BottomSheetViewController {
    @objc
    func didTapAddCategoryButton() {
        guard let enteredText = textField.text, !enteredText.isEmpty else {
            print("TextField is empty")
            // сделать проверку на существующую категорию
            // пробрасывать ошибку, если возможно
            return
        }
        print("Entered text: \(enteredText)")
    }

    @objc
    func didTapAddCategoryView() {
        imagePicker.showImagePicker(with: self) { image in
            self.didSelectImage(image)
        }
    }

    func didSelectImage(_ image: UIImage) {
        addCategoryView.setImage(with: image)
    }

    func setVisualAppearance() {
        addCategoryButton.setTitle(Consts.AddCategoryButton.title, for: .normal)
        addCategoryButton.backgroundColor = .PrimaryColors.Button.blue
        addCategoryButton.layer.cornerRadius = 16
        textField.placeholder = Consts.TextField.text
        textField.tintColor = .gray
        textField.borderStyle = .roundedRect
    }

    func setAddCategoryView() {
        addCategoryView.translatesAutoresizingMaskIntoConstraints = false
        addCategoryView.topAnchor.constraint(equalTo: view.topAnchor, constant:
                                                view.frame.width / 5.5).isActive = true
        addCategoryView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:
                                                view.frame.width / 2 - view.frame.width / 8).isActive = true
        addCategoryView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:
                                                -view.frame.width / 2 + view.frame.width / 8).isActive = true
        addCategoryView.heightAnchor.constraint(equalToConstant: view.frame.width / 4 + 10).isActive = true
    }

    func setTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:
                                        UIConstants.TextField.leading).isActive = true
        textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:
                                       -UIConstants.TextField.trailing).isActive = true
        textField.topAnchor.constraint(equalTo: addCategoryView.bottomAnchor, constant:
                                        view.frame.width / 10).isActive = true
        textField.heightAnchor.constraint(equalToConstant:
                                        UIConstants.TextField.height).isActive = true
    }

    func setAddCategoryButton() {
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        addCategoryButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant:
                                                view.frame.width / 20).isActive = true
        addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:
                                                UIConstants.AddCategoryButton.leading).isActive = true
        addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:
                                                -UIConstants.AddCategoryButton.trailing).isActive = true
        addCategoryButton.heightAnchor.constraint(equalToConstant:
                                                UIConstants.AddCategoryButton.height).isActive = true
    }
}
// swiftlint:disable nesting
private extension BottomSheetViewController {
    struct Consts {
        struct TextField {
            static let text: String = "Название категории"
        }
        struct AddCategoryButton {
            static let title: String = "Добавить категорию"
        }
    }

    struct UIConstants {
        struct TextField {
            static let leading: CGFloat = 37.0
            static let trailing: CGFloat = 37.0
            static let height: CGFloat = 60.0
        }

        struct AddCategoryButton {
            static let leading: CGFloat = 37.0
            static let trailing: CGFloat = 37.0
            static let height: CGFloat = 60.0
        }
    }
}
// swiftlint:enable nesting
