//
//  UserInformationView.swift
//  easyLanguage
//
//  Created by Арсений Чистяков on 06.12.2023.
//  View с фотографией, именем и фамилией пользователя

import UIKit

protocol UserInformationViewOutput {
    func getSize() -> CGFloat
}

protocol UserInformationViewDelegate: AnyObject {
    func didTapImage()
}

final class UserInformationView: UIView {
    // MARK: - Init components
    private var imageView = UIImageView()
    private let firstNameTextField = UITextField()
    private let lastNameTextField = UITextField()

    weak var delegate: UserInformationViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        [imageView, firstNameTextField, lastNameTextField].forEach {
            self.addSubview($0)
        }
        setTipAppearance()
        setImageView()
        setFirstNameTextField()
        setLastNameTextField()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Open methods
extension UserInformationView {
    // Первые две функции пока не работают
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
}

extension UserInformationView: UserInformationViewOutput {
    func getSize() -> CGFloat {
        Image.marginTop + Image.imageSize + TextFields.height * 2 + FirstName.marginTop + LastName.marginTop
    }
}

// MARK: - Private methods
private extension UserInformationView {
    func setTipAppearance() {
        setUpImage()
        firstNameTextField.text = FirstName.text
        lastNameTextField.text = LastName.text
        setUpTextField(firstNameTextField)
        setUpTextField(lastNameTextField)
    }

    func setUpImage() {
        imageView.image = UIImage(systemName: "person.circle")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .gray
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        imageView.addGestureRecognizer(tapGesture)
    }

    @objc func didTapImage() {
        delegate?.didTapImage()
    }
//    @objc func didTapImage() {
//        imagePicker.showImagePicker(with: self) { [weak self] image in
//                    self?.didSelectImage(image)
//                }
//    }
//    
//    func didSelectImage(_ image: UIImage) {
//        imageView.image = image
//        }
    
    func setUpTextField(_ textField: UITextField) {
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 15
        textField.isUserInteractionEnabled = false
    }

    // MARK: - Layouts
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

// MARK: - Contsants
private extension UserInformationView {
    struct Image {
        static let imageSize: CGFloat = 130
        static let marginTop: CGFloat = 20
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



protocol ImageSelectionDelegate: AnyObject {
    func didSelectImage(_ image: UIImage)
}

class YourCustomView: UIView {
    
    weak var delegate: ImageSelectionDelegate?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Добавляем жест нажатия на UIImageView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(tapGesture)
        
        addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func imageTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        // Проверяем, есть ли у нас контроллер, к которому мы можем привязать UIImagePickerController
        var responder: UIResponder? = self
        while responder != nil {
            if let viewController = responder as? UIViewController {
                viewController.present(imagePickerController, animated: true, completion: nil)
                break
            }
            responder = responder?.next
        }
    }
}

extension YourCustomView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = pickedImage
            
            // Уведомляем делегата о выборе изображения
            delegate?.didSelectImage(pickedImage)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
