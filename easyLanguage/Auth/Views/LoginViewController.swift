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
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.text = "Войти"
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
        loginField.placeholder = "Почта"
        loginField.layer.cornerRadius = 10
        loginField.backgroundColor = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1)
        loginField.borderStyle = .roundedRect

        let passwordField = UITextField(frame: CGRect(x: 0, y: 0, width: 343, height: 50))
        passwordField.placeholder = "Пароль"
        passwordField.layer.cornerRadius = 10
        passwordField.backgroundColor = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1)
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
        button.setTitle("Войти", for: .normal)
        button.backgroundColor = UIColor.PrimaryColors.Button.blue
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
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
        view.backgroundColor = .white
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
    private func tapButton() {
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
                self.navigationController?.pushViewController(OnboardingViewController(), animated: true)
            }
        }
    }
}
