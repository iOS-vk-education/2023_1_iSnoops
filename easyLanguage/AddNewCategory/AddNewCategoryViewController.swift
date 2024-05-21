//
//  AddNewCategoryViewController.swift
//  easyLanguage
//
//  Created by Grigoriy on 04.12.2023.
//
// Всплывающий экран для добавления новой категории

import UIKit

protocol AddNewCategoryOutput: AnyObject {
    func categoryDidAdded(with categoryModel: CategoryModel)
    func isCategoryExist(with title: String) -> Bool
}

final class AddNewCategoryViewController: UIViewController {
    private let imageView: UIImageView = UIImageView()
    private let advice: UILabel = UILabel()
    private let textField: UITextField = UITextField()
    private let button: UIButton = UIButton()

    private var horizontalPadding: CGFloat = 0
    private var selectedImage: UIImage?

    private let imagePicker = ImagePicker()
    private let model = AddNewCategoryModel()
    private let pushManager = PushManager.shared

    weak var delegate: AddNewCategoryOutput?
}

extension AddNewCategoryViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .PrimaryColors.Background.background
        [imageView, advice, textField, button].forEach {
            view.addSubview($0)
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)

        setAppearance()
        addConstraints()
    }

    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc
    func didTapImage() {
        imagePicker.showImagePicker(with: self) { [weak self] image in
            self?.imageView.image = image
            self?.selectedImage = image
        }
    }

    @objc
    func didTapButton() {
        @Trimmed var enteredText = textField.text ?? ""

        guard !enteredText.isEmpty else {
            return
        }

        guard let delegate = delegate else {
            AlertManager.showAddNewCategoryAlert(on: self)
            return
        }

        if delegate.isCategoryExist(with: enteredText) {
            AlertManager.showAlert(
                on: self,
                title: NSLocalizedString(
                    "categoryAlreadyExists",
                    comment: ""
                ),
                message: ""
            )
            return
        }

        model.createNewCategory(with: enteredText, image: selectedImage) { [weak self] result in
            guard let self else {
                return
            }

            switch result {
            case .success(let categoryModel):
                delegate.categoryDidAdded(with: categoryModel)

                if !UserDefaults.standard.bool(forKey: .isCompletedCreateFirstCategory) {
                    pushManager.requestAuth { [weak self] status in
                        self?.pushManager.getStatus { status in
                            if status == .allowed {
                                self?.sendNotification()
                            }
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }

            DispatchQueue.main.async {
                self.textField.text = nil
                self.dismiss(animated: true)
            }
        }
    }
}

// MARK: - Pushes

private extension AddNewCategoryViewController {
    func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("categoryAchivmentTitle", comment: "")
        content.body = NSLocalizedString("categoryAchivmentBody", comment: "")
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(
            identifier: .isCompletedCreateFirstCategory,
            content: content,
            trigger: trigger
        )

        pushManager.add(notification: request)
        UserDefaults.standard.set(true, forKey: .isCompletedCreateFirstCategory)
    }
}

// MARK: - set appearance elements
private extension AddNewCategoryViewController {
    func setAppearance() {
        configureImageView()
        configureAdvice()
        configureTextField()
        configureButton()
    }

    func configureImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "plus-signIconImage")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        imageView.addGestureRecognizer(tapGesture)
    }

    func configureAdvice() {
        advice.text = NSLocalizedString("addPhotoAdvice", comment: "")
        advice.textAlignment = .center
    }

    func configureButton() {
        button.setTitle(NSLocalizedString("addCategoryButtonTitle", comment: ""), for: .normal)
        button.backgroundColor = .PrimaryColors.Button.blue
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }

    func configureTextField() {
        textField.placeholder = NSLocalizedString("categoryNamePlaceholder", comment: "")
        textField.tintColor = .gray
        textField.backgroundColor = .PrimaryColors.TextField.fieldColor
        textField.borderStyle = .roundedRect
    }
}

// MARK: - set constraints
private extension AddNewCategoryViewController {
    func addConstraints() {
        horizontalPadding = view.bounds.width / 10
        setImageView()
        setAdvice()
        setTextField()
        setButton()
    }

    func setImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.topAnchor,
                                      constant: view.bounds.height / 10).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: view.bounds.width / 4).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: view.bounds.width / 4).isActive = true
    }

    func setAdvice() {
        advice.translatesAutoresizingMaskIntoConstraints = false
        advice.topAnchor.constraint(equalTo: imageView.bottomAnchor,
                                    constant: 5).isActive = true
        advice.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        advice.widthAnchor.constraint(equalToConstant: view.bounds.width / 2).isActive = true
        advice.sizeToFit()
    }

    func setTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.topAnchor.constraint(equalTo: advice.bottomAnchor,
                                                  constant: 20).isActive = true
        textField.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                  constant: horizontalPadding).isActive = true
        textField.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                  constant: -horizontalPadding).isActive = true
        textField.heightAnchor.constraint(equalToConstant:
                                                  view.bounds.height / 15).isActive = true
    }

    func setButton() {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: textField.bottomAnchor,
                                               constant: 10).isActive = true
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                               constant: horizontalPadding).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                               constant: -horizontalPadding).isActive = true
        button.heightAnchor.constraint(equalToConstant:
                                               view.bounds.height / 15).isActive = true
    }
}
