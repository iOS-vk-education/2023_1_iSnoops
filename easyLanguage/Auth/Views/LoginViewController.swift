//
//  LoginViewController.swift
//  loginViews
//
//  Created by Матвей Матюшко on 16.12.2023.
//
import Foundation
import UIKit
import FirebaseAuth

final class LoginViewController: UIViewController {
    // MARK: Views
    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = TextStyle.header.font
        label.text = NSLocalizedString("loginTitle", comment: "")
        return label
    }()

    private lazy var loginPasswordInput: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let loginField = UITextField(frame: CGRect(x: 0, y: 0, width: 343, height: 50))
        loginField.placeholder = NSLocalizedString("emailPlaceholder", comment: "")
        loginField.layer.cornerRadius = 10
        loginField.backgroundColor = UIColor.PrimaryColors.TextField.fieldColor
        loginField.borderStyle = .roundedRect

        let passwordField = UITextField(frame: CGRect(x: 0, y: 0, width: 343, height: 50))
        passwordField.placeholder = NSLocalizedString("passwordPlaceholder", comment: "")
        passwordField.layer.cornerRadius = 10
        passwordField.backgroundColor = UIColor.PrimaryColors.TextField.fieldColor
        passwordField.isSecureTextEntry = !passwordField.isSecureTextEntry
        passwordField.borderStyle = .roundedRect

        let showPassword = UIButton(type: .custom, primaryAction: UIAction {_ in
            passwordField.isSecureTextEntry.toggle()
        })
        showPassword.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        passwordField.rightViewMode = .always
        passwordField.rightView = showPassword

        stackView.addArrangedSubview(loginField)
        stackView.addArrangedSubview(passwordField)
        return stackView
    }()

    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = TextStyle.bodyMedium.font
        button.setTitle(NSLocalizedString("loginTitle", comment: ""), for: .normal)
        button.backgroundColor = UIColor.PrimaryColors.Button.blue
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(tapLoginButton), for: .touchUpInside)
        return button
    }()
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTitleLabelConstraints()
        setupLoginPasswordInputConstraints()
        setupButtonConstraints()
    }
    // MARK: Private methods
    private func setupViews() {
        view.backgroundColor = .PrimaryColors.Background.background
        view.addSubview(titleLabel)
        view.addSubview(loginPasswordInput)
        view.addSubview(loginButton)
    }

    private func setupTitleLabelConstraints() {
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
    }

    private func setupLoginPasswordInputConstraints() {
        loginPasswordInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        loginPasswordInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        loginPasswordInput.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32).isActive = true
        loginPasswordInput.heightAnchor.constraint(equalToConstant: view.frame.height / 8).isActive = true
    }

    private func setupButtonConstraints() {
        loginButton.topAnchor.constraint(equalTo: loginPasswordInput.bottomAnchor, constant: 90).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 51).isActive = true
    }

    @objc
    private func tapLoginButton() {
        // логика входа
        guard let fields = loginPasswordInput.arrangedSubviews as? [UITextField] else {
            return
        }
        guard let emailString = fields[0].text,
              let passwordString = fields[1].text
        else {
            return
        }
        let userRequest = LoginUserRequest(email: emailString,
                                           password: passwordString)
        AuthService.shared.signIn(with: userRequest) { error in
            if let maybeError = error {
                let nsError = maybeError as NSError
                switch nsError.code {
                case AuthErrorCode.invalidEmail.rawValue:
                    AlertManager.showInvalidEmailAlert(on: self)
                default:
                    AlertManager.showSignInErrorAlert(on: self)
                }
                return
            } else {
                let controller = TabBarController()
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
}
