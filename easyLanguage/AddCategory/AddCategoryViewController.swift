//
//  AddCategoryViewController.swift
//  CustomBottomSheet
//
//  Created by Grigoriy on 19.11.2023.
//

import UIKit

class AddCategoryViewController: CustomViewController {
    private let visualBar = UIView()
    private let addCategoryView = AddCategoryView()
    private let textField: UITextField = UITextField()
    private let addCategoryButton: UIButton = UIButton()
    private let imagePicker = ImagePicker()
    var selectedImage: UIImage?
    weak var delegate: BottomSheetDelegate? //FIXME: name исправить

    init(delegate: BottomSheetDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Circle
extension AddCategoryViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        [visualBar, addCategoryView, addCategoryButton, textField].forEach {
            view.addSubview($0)
        }

        setVisualAppearance()
        setTextField()
        setAddCategoryButton()
        setAddCategoryView()
        setVisualBar()

        addCategoryView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapAddCategoryView))
        addCategoryView.addGestureRecognizer(tapGesture)
        addCategoryButton.addTarget(self, action: #selector(didTapAddCategoryButton), for: .touchUpInside)
    }
}

private extension AddCategoryViewController {
    @objc
    func didTapAddCategoryButton() {
        guard let enteredText = textField.text, !enteredText.isEmpty else {
            print("TextField is empty")
            // сделать проверку на существующую категорию
            // пробрасывать ошибку, если возможно
            return
        }
        delegate?.createCategory(with: CategoryUIModel(title: ["ru": enteredText],
                                                       image: selectedImage,
                                                       studiedWordsCount: 0,
                                                       totalWordsCount: 0,
                                                       createdDate: Date(),
                                                       linkedWordsId: UUID().uuidString))
    }

    @objc
    func didTapAddCategoryView() {
        imagePicker.showImagePicker(with: self) { image in
            self.didSelectImage(image)
        }
    }

    func didSelectImage(_ image: UIImage) {
        selectedImage = image
        addCategoryView.setImage(with: image)
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

    func setVisualAppearance() {
        visualBar.layer.cornerRadius = 4
        visualBar.backgroundColor = .gray
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
                                        UIConstants.TextField.horizontally).isActive = true
        textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:
                                       -UIConstants.TextField.horizontally).isActive = true
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
private extension AddCategoryViewController {
    struct Consts {
        struct TextField {
            static let text: String = "Название категории"
        }
        struct AddCategoryButton {
            static let title: String = "Добавить категорию"
        }
    }

    struct UIConstants {
        struct VisualBar {
            static let top: CGFloat = 10.0
            static let height: CGFloat = 8.0
        }

        struct TextField {
            static let horizontally: CGFloat = 37.0 // FIXME: - поменять
            static let height: CGFloat = 60.0  // FIXME: - поменять
        }

        struct AddCategoryButton {
            static let leading: CGFloat = 37.0
            static let trailing: CGFloat = 37.0
            static let height: CGFloat = 60.0
        }
    }
}
// swiftlint:enable nesting
