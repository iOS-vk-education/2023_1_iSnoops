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
        label.font = TextStyle.header.font
        label.text = NSLocalizedString("registrationTitle", comment: "")
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
        nameField.placeholder = NSLocalizedString("namePlaceholder", comment: "")
        nameField.layer.cornerRadius = 10
        nameField.backgroundColor = UIColor.PrimaryColors.TextField.fieldColor
        nameField.borderStyle = .roundedRect

        let loginField = UITextField(frame: CGRect(x: 0, y: 0, width: 343, height: 50))
        loginField.placeholder =  NSLocalizedString("emailPlaceholder", comment: "")
        loginField.layer.cornerRadius = 10
        loginField.backgroundColor = UIColor.PrimaryColors.TextField.fieldColor
        loginField.borderStyle = .roundedRect

        let passwordField = UITextField(frame: CGRect(x: 0, y: 0, width: 343, height: 50))
        passwordField.placeholder =  NSLocalizedString("passwordPlaceholder", comment: "")
        passwordField.layer.cornerRadius = 10
        passwordField.backgroundColor = UIColor.PrimaryColors.TextField.fieldColor
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
        button.titleLabel?.font = TextStyle.bodyMedium.font
        button.setTitle(NSLocalizedString("registrationButtonTitle", comment: ""), for: .normal)
        button.backgroundColor = UIColor.PrimaryColors.Button.blue
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        return button
    }()

    private let defaultData = DefaultData.shared

    private let categoryService = AddNewCategoryService.shared
    private let wordService = AddWordService.shared
    private let topFiveService = LearningViewService.shared

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
        let pushToLoginViewButton = UIBarButtonItem(title: NSLocalizedString("loginTitle", comment: ""),
                                                    style: .plain,
                                                    target: self,
                                                    action: #selector(tapLoginButton))
        navigationItem.rightBarButtonItems = [pushToLoginViewButton]
        view.backgroundColor = .PrimaryColors.Background.background
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
            return
        }
        guard let emailString = labels[1].text,
              let passwordString = labels[2].text
        else {
            return
        }
        // логика регистрации
        let userRequest = RegisterUserRequest(username: labels[0].text ?? "",
                                              email: emailString,
                                              password: passwordString,
                                              userId: "")
        AuthService.shared.registerUser(with: userRequest) { [weak self] _, error in
            guard let self else {
                // TODO: - add Alert
                return
            }

            if let maybeError = error {
                let nsError = maybeError as NSError
                switch nsError.code {
                case AuthErrorCode.weakPassword.rawValue:
                    AlertManager.showWeakPassword(on: self)
                case AuthErrorCode.invalidEmail.rawValue:
                    AlertManager.showInvalidEmailAlert(on: self)
                case AuthErrorCode.emailAlreadyInUse.rawValue:
                    AlertManager.showEmailAlreadyInUse(on: self)
                default:
                    AlertManager.showRegistrationErrorAlert(on: self)
                }
                return
            }

            self.addDefaultData()

            guard UserDefaults.standard.string(forKey: "onboardingCompleted") != nil else {
                self.navigationController?.pushViewController(OnboardingViewController(), animated: true)
                return
            }
            self.navigationController?.pushViewController(TabBarController(), animated: true)
        }
    }

    private func addDefaultData() {
        for category in defaultData.getCategories() {
            Task {
                do {
                    _ = try await categoryService.createNewCategory(with: category, image: nil)
                } catch {
                    print("[DEBUG]:", #function, error.localizedDescription)
                }
            }
        }

        for word in defaultData.getTopFive() {
            Task {
                do {
                    _ = try await topFiveService.createNewTopFiveWord(with: word)
                } catch {
                    print("[DEBUG]:", #function, error.localizedDescription)
                }
            }
        }

        for word in defaultData.getWords() {
            wordService.add(word, completion: { _ in })
        }
    }

    @objc
    private func tapLoginButton() {
        navigationController?.pushViewController(LoginViewController(), animated: true)
    }
}
