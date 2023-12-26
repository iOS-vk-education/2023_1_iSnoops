//
//  RegistrationViewController.swift
//  loginViews
//
//  Created by Матвей Матюшко on 16.12.2023.
//

import Foundation
import UIKit
import FirebaseAuth

final class RegistrationViewController: UIViewController {
    // MARK: Views
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.text = "Регистрация"
        return label
    }()
    
    private lazy var loginPasswordInput: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let nameField = UITextField(frame: CGRect(x: 0, y: 0, width: 343, height: 50))
        nameField.placeholder = "Имя"
        nameField.layer.cornerRadius = 10
        nameField.backgroundColor = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1)
        nameField.borderStyle = .roundedRect
        
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
        
        let showPassword = UIButton(type: .system, primaryAction: UIAction {_ in
            passwordField.isSecureTextEntry.toggle()
        })
        showPassword.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        passwordField.rightViewMode = .always
        passwordField.rightView = showPassword
        
        stackView.addArrangedSubview(nameField)
        stackView.addArrangedSubview(loginField)
        stackView.addArrangedSubview(passwordField)
        
        return stackView
    }()
    
    private lazy var registrationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Зарегестрироваться", for: .normal)
        button.backgroundColor = UIColor.PrimaryColors.Button.blue
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        return button
    }()
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Регистрация"
        setupViews()
        setupTitleLabelConstraints()
        setupLoginPasswordInputConstraints()
        setupButtonConstraints()
    }
    // MARK: Private methods
    private func setupViews() {
        let pushToLoginView = UIBarButtonItem(title: "Войти", style: .plain, target: self, action: #selector(tapLoginButton))
        navigationItem.rightBarButtonItems = [pushToLoginView]
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(loginPasswordInput)
        view.addSubview(registrationButton)
    }
    
    private func setupTitleLabelConstraints() {
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
    }
    
    private func setupLoginPasswordInputConstraints() {
        loginPasswordInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        loginPasswordInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        loginPasswordInput.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32).isActive = true
        loginPasswordInput.heightAnchor.constraint(equalToConstant: view.frame.height / 6).isActive = true
    }
    
    private func setupButtonConstraints() {
        registrationButton.topAnchor.constraint(equalTo: loginPasswordInput.bottomAnchor, constant: 90).isActive = true
        registrationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        registrationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        registrationButton.heightAnchor.constraint(equalToConstant: 51).isActive = true
    }
    @objc
    private func tapButton() {
        guard let labels = loginPasswordInput.arrangedSubviews as? [UITextField] else {
            print("net subviews")
            return }
        guard let emailString = labels[1].text,
              let passwordString = labels[2].text
        else {
            return
        }
        // логика регистрации
        let userRequest = RegisterUserRequest(username: labels[0].text ?? "",
                                              email: emailString,
                                              password: passwordString)
        AuthService.shared.registerUser(with: userRequest) { wasRegister, error in
            if let error = error {
                let err = error as NSError
                switch err.code {
                case AuthErrorCode.weakPassword.rawValue:
                    AlertManager.showCodeWeakPassword(on: self)
                case AuthErrorCode.invalidEmail.rawValue:
                    AlertManager.showInvalidEmailAlert(on: self)
                case AuthErrorCode.emailAlreadyInUse.rawValue:
                    AlertManager.showEmailAlreadyInUse(on: self)
                default:
                    print("unknown error: \(err.localizedDescription)")
                }
                print(error.localizedDescription)
                return
            }
            print(wasRegister)
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
        
    }
    
    @objc
    private func tapLoginButton() {
        navigationController?.pushViewController(LoginViewController(), animated: true)
    }
}
