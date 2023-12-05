//
//  AddNewCategoryViewController.swift
//  easyLanguage
//
//  Created by Grigoriy on 04.12.2023.
//
// Всплывающий экран для добавления новой категории

import UIKit

class AddCategoryViewController: CustomViewController {
    private let addCategoryImageView: UIImageView = UIImageView()
    private let addCategoryLabel: UILabel = UILabel()
    private let newCategoryTextField: UITextField = UITextField()
    private let addCategoryButton: UIButton = UIButton()
//    private let imagePicker = ImagePicker()
    private var selectedImage: UIImage?
//    weak var delegate: AddNewCategoryDelegate?
//
//    init(delegate: AddNewCategoryDelegate) {
//        super.init(nibName: nil, bundle: nil)
//        self.delegate = delegate
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
}

// MARK: - Life Circle
extension AddCategoryViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        [addCategoryImageView, addCategoryLabel, newCategoryTextField, addCategoryButton].forEach {
            view.addSubview($0)
        }

        setVisualAppearance()

        setAddCategoryImageView()
        setAddCategoryLabel()
        setNewCategorytextField()
        setAddCategoryButton()
        setDismissKeyboard()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapAddCategoryView))
        addCategoryImageView.addGestureRecognizer(tapGesture)
        addCategoryButton.addTarget(self, action: #selector(didTapAddCategoryButton), for: .touchUpInside)
    }
}

// MARK: - private methods
private extension AddCategoryViewController {
    @objc
    func didTapAddCategoryButton() {
        guard let enteredText = newCategoryTextField.text, !enteredText.isEmpty else {
            print("TextField is empty")
            // сделать проверку на существующую категорию
            // пробрасывать ошибку, если возможно
            return
        }
//
//        delegate?.createCategory(with: CategoryUIModel(title: ["ru": enteredText],
//                                                       image: selectedImage,
//                                                       studiedWordsCount: 0,
//                                                       totalWordsCount: 0,
//                                                       createdDate: Date(),
//                                                       linkedWordsId: UUID().uuidString))
        newCategoryTextField.text = nil
        dismiss(animated: true)
    }

    @objc
    func didTapAddCategoryView() {
//        imagePicker.showImagePicker(with: self) { [weak self] image in
//            self?.didSelectImage(image)
//        }
    }

    func didSelectImage(_ image: UIImage) {
        selectedImage = image
//        addCategoryView.setImage(with: image)
    }

    func setDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func setVisualAppearance() {
        addCategoryButton.setTitle(Consts.AddCategoryButton.title, for: .normal)
        addCategoryButton.backgroundColor = .red  // FIXME: занести нужный цвет
        addCategoryButton.layer.cornerRadius = Consts.AddCategoryButton.cornerRadius

        newCategoryTextField.placeholder = Consts.NewCategoryTextField.text
        newCategoryTextField.tintColor = .gray
        newCategoryTextField.borderStyle = .roundedRect

        addCategoryImageView.contentMode = .scaleAspectFill
        addCategoryImageView.clipsToBounds = true
        addCategoryImageView.image = Consts.AddCategoryImageView.image

        addCategoryLabel.text = Consts.AddCategoryLabel.text
        addCategoryLabel.textAlignment = .center
    }

    func setAddCategoryImageView() {
        addCategoryImageView.translatesAutoresizingMaskIntoConstraints = false
        addCategoryImageView.topAnchor.constraint(equalTo: view.topAnchor,
                                                  constant: UIConstants.AddCategoryImageView.top).isActive = true
        addCategoryImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addCategoryImageView.heightAnchor.constraint(equalToConstant: view.frame.width / 4).isActive = true
        addCategoryImageView.widthAnchor.constraint(equalToConstant: view.frame.width / 4).isActive = true
    }

    func setAddCategoryLabel() {
        addCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        addCategoryLabel.topAnchor.constraint(equalTo: addCategoryImageView.bottomAnchor,
                                              constant: UIConstants.AddCategoryLabel.top).isActive = true
        addCategoryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addCategoryLabel.widthAnchor.constraint(equalToConstant: view.frame.width / 2).isActive = true
        addCategoryLabel.sizeToFit()
    }

    func setNewCategorytextField() {
        newCategoryTextField.translatesAutoresizingMaskIntoConstraints = false
        newCategoryTextField.topAnchor.constraint(equalTo: addCategoryLabel.bottomAnchor,
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
// MARK: - Consts
// swiftlint:disable nesting
private extension AddCategoryViewController {
    struct Consts {
        struct AddCategoryImageView {
            static let image: UIImage = UIImage(named: "plus-signIconImage")!
        }

        struct AddCategoryLabel {
            static let text: String = "добавить фото"
        }

        struct NewCategoryTextField {
            static let text: String = "Название категории"
        }

        struct AddCategoryButton {
            static let title: String = "Добавить категорию"
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
