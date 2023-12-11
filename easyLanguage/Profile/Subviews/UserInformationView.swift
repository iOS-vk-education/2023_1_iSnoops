//
//  UserInformationView.swift
//  easyLanguage
//
//  Created by Арсений Чистяков on 06.12.2023.
//  View с фотографией, именем и фамилией пользователя

import UIKit

protocol UserInformationViewDelegate: AnyObject {
    func presentImagePicker()
}

final class UserInformationView: UIView {
    // MARK: - init image, first & last name textfield
    private let imageView = UIImageView()
    private let firstNameTextField = UITextField()
    private let lastNameTextField = UITextField()

    weak var delegate: UserInformationViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        [imageView, firstNameTextField, lastNameTextField].forEach {
            self.addSubview($0)
        }
        setVisualAppearance()
        setImageView()
        setFirstNameTextField()
        setLastNameTextField()
        setupImageViewTapGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupImageViewTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
    }

    @objc private func imageTapped() {
        delegate?.presentImagePicker()
    }
}
// MARK: - open methods
extension UserInformationView: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo
                               info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == firstNameTextField {
            if let firstName = textField.text {
                print("Имя: \(firstName)")
            }
        } else if textField == lastNameTextField {
            if let lastName = textField.text {
                print("Фамилия: \(lastName)")
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func getSize() -> CGFloat {
        return Image.marginTop + Image.imageSize + TextFields.height * 2 + FirstName.marginTop + LastName.marginTop
    }
}

// MARK: - private methods
private extension UserInformationView {
    func setVisualAppearance() {
        setUpImage(imageView)
        firstNameTextField.text = FirstName.text
        lastNameTextField.text = LastName.text
        setUpTextField(firstNameTextField)
        setUpTextField(lastNameTextField)
    }

    func setUpImage(_ image: UIImageView) {
        image.image = UIImage(named: "ProfileEmptyImage")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = imageView.frame.size.width / 2
        image.layer.borderWidth = 2.0
        image.layer.borderColor = UIColor.white.cgColor
        image.isUserInteractionEnabled = true
    }

    func setUpTextField(_ textField: UITextField) {
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 15
    }

    // MARK: - layouts
    func setImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: Image.marginTop).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: Image.imageSize).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: Image.imageSize).isActive = true
    }

    func setFirstNameTextField() {
        firstNameTextField.translatesAutoresizingMaskIntoConstraints = false
        firstNameTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor,
                                                constant: FirstName.marginTop).isActive = true
        firstNameTextField.leftAnchor.constraint(equalTo: self.leftAnchor,
                                                 constant: TextFields.marginLeft).isActive = true
        firstNameTextField.widthAnchor.constraint(equalTo: self.widthAnchor,
                                                  constant: TextFields.marginRight).isActive = true
        firstNameTextField.heightAnchor.constraint(equalToConstant: TextFields.height).isActive = true
    }

    func setLastNameTextField() {
        lastNameTextField.translatesAutoresizingMaskIntoConstraints = false
        lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor,
                                               constant: LastName.marginTop).isActive = true
        lastNameTextField.leftAnchor.constraint(equalTo: self.leftAnchor, constant:
                                                    TextFields.marginLeft).isActive = true
        lastNameTextField.widthAnchor.constraint(equalTo: self.widthAnchor, constant:
                                                    TextFields.marginRight).isActive = true
        lastNameTextField.heightAnchor.constraint(equalToConstant: TextFields.height).isActive = true
    }
}

class UserInformationProfileController: UIViewController,
                                        UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    private lazy var userInformationView = UserInformationView()

    override func viewDidLoad() {
        userInformationView.delegate = self
    }
}

// MARK: - UserInformationViewDelegate
extension UserInformationProfileController: UserInformationViewDelegate {
    func presentImagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
}

// MARK: - structures
private extension UserInformationView {
    struct Image {
        static let imageSize: CGFloat = 130
        static let marginTop: CGFloat = 10
    }

    struct TextFields {
        static let marginLeft: CGFloat = 20
        static let marginRight: CGFloat = -40
        static let height: CGFloat = 30
    }

    struct FirstName {
        static let marginTop: CGFloat = 30
        static let text: String = "Арсений"
    }

    struct LastName {
        static let marginTop: CGFloat = 5
        static let text: String = "Чистяков"
    }
}
