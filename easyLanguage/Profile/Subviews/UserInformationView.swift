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
    private let mailTextField = UITextField()

    weak var delegate: UserInformationViewDelegate?

    private let imageManager = ImageManager.shared

    override init(frame: CGRect) {
        super.init(frame: frame)
        setAppearanseAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Open methods
extension UserInformationView {
    func setImage(imageLink: String) {
        guard let url = URL(string: imageLink) else {
            return
        }
        imageManager.loadImage(from: url) { [weak self] result in
            guard let self else {
                return
            }
            switch result {
            case .success(let data):
                self.imageView.image = UIImage(data: data)
            case .failure(let error):
                print("ошибка получения изображения", error.localizedDescription)
            }
        }
    }

    func setTextFields(with model: ProfileApiModel) {
        firstNameTextField.text = model.name
        mailTextField.text = model.email
    }
}

extension UserInformationView: UserInformationViewOutput {
    func getSize() -> CGFloat {
        Image.marginTop + Image.imageSize + TextFields.height * 2 + FirstName.marginTop + Mail.marginTop
    }
}

// MARK: - set all constraints
private extension UserInformationView {
    func setAppearanseAndConstraints() {
        [imageView, firstNameTextField, mailTextField].forEach {
            self.addSubview($0)
        }
        setTipAppearance()
        setImageView()
        setFirstNameTextField()
        setMailTextField()
    }
}

// MARK: - Private methods
private extension UserInformationView {
    func setTipAppearance() {
        setUpImage()
        firstNameTextField.font = TextStyle.bodyMedium.font
        mailTextField.font = TextStyle.bodyMedium.font
        setUpTextField(firstNameTextField)
        setUpTextField(mailTextField)
    }

    func setUpImage() {
        imageView.image = UIImage(systemName: "person.circle")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .gray
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Image.imageSize / 2
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        imageView.addGestureRecognizer(tapGesture)
    }

    @objc func didTapImage() {
        delegate?.didTapImage()
    }

    func setUpTextField(_ textField: UITextField) {
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 15
        textField.isUserInteractionEnabled = false
        textField.layer.borderColor = UIColor.white.cgColor
        textField.backgroundColor = .PrimaryColors.Background.background
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

    func setMailTextField() {
        mailTextField.translatesAutoresizingMaskIntoConstraints = false
        mailTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor,
                                               constant: Mail.marginTop).isActive = true
        mailTextField.leftAnchor.constraint(equalTo: self.leftAnchor, constant:
                                                    TextFields.marginLeft).isActive = true
        mailTextField.widthAnchor.constraint(equalTo: self.widthAnchor, constant:
                                                    TextFields.marginRight).isActive = true
        mailTextField.heightAnchor.constraint(equalToConstant: TextFields.height).isActive = true
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
    }

    struct Mail {
        static let marginTop: CGFloat = 5
    }
}
