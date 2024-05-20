//
//  RegistrationViewController.swift
//  loginViews
//
//  Created by Матвей Матюшко on 16.12.2023.
//

import Foundation
import UIKit
import FirebaseAuth
import CoreData

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
    private let topFiveCDService = TopFiveWordsCDService()

    private let categoryService = AddNewCategoryService.shared
    private let wordService = AddWordService.shared
    private let topFiveService = LearningViewService.shared
    private let coreData = CoreDataService()

    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTitleLabelConstraints()
        setupLoginPasswordInputConstraints()
        setupButtonConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        enableButton(button: registrationButton)
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
        disableButton(button: registrationButton)
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
                self.enableButton(button: self.registrationButton)
                return
            }
            
            setTopFiveToCD()
            
            Task {
                await self.addDefaultData()
                
                if UserDefaults.standard.string(forKey: "onboardingCompleted") == nil {
                    let onboardingVC = OnboardingViewController()
                    onboardingVC.modalPresentationStyle = .fullScreen
                    await MainActor.run {
                        self.present(onboardingVC, animated: true, completion: nil)
                    }
                } else {
                    let tabBarController = TabBarController()
                    tabBarController.modalPresentationStyle = .fullScreen
                    await MainActor.run {
                        self.present(tabBarController, animated: true, completion: nil)
                    }
                }
            }
        }
    }

    private func setTopFiveToCD () {
        guard let userId = checkAuthentication() else {
            return
        }
        topFiveCDService.saveWordsToCoreData(words: defaultData.getTopFive(), userId: userId)
    }

        private func addDefaultData() async {
                for category in defaultData.getCategories() {
                    do {
                        let data = await asyncConvert(link: category.imageLink)
                        coreData.saveCategory(with: category, imageData: data)
                        // _ = try await categoryService.createNewCategory(with: category, image: nil)
                    } catch {
                        print("[DEBUG]:", #function, error.localizedDescription)
                    }
                }

        for word in defaultData.getTopFive() {
            Task {
                do {
                    // TODO: - Сене добавить с топ5 словами
                    _ = try await topFiveService.createNewTopFiveWord(with: word)
                } catch {
                    print("[DEBUG]:", #function, error.localizedDescription)
                }
            }
        }

        for word in defaultData.getWords() {
            // TODO: - Матвею поправить с добавлением словам ( убрать из сервиса) и тут сделать чтобы все ок было
            wordService.add(word, completion: { _ in })
        }
    }

    private func checkAuthentication() -> String? {
        if let currentUser = Auth.auth().currentUser {
            return currentUser.uid
        }
        return nil
    }

    private func asyncConvert(link: String?) async -> Data? {
        if let link = link, let imageLink = URL(string: link) {
            return await withCheckedContinuation { continuation in
                ImageManager.shared.loadImage(from: imageLink) { result in
                    switch result {
                    case .success(let data):
                        continuation.resume(returning: data)
                    case .failure(let error):
                        print(#function, "не удалось загрузить изображение", error.localizedDescription)
                        continuation.resume(returning: nil)
                    }
                }
            }
        }
        return nil
    }

    @objc
    private func tapLoginButton() {
        navigationController?.pushViewController(LoginViewController(), animated: true)
    }

    private func disableButton(button: UIButton) {
        button.isEnabled = false
        button.backgroundColor = UIColor.gray
    }
    private func enableButton(button: UIButton) {
        button.isEnabled = true
        button.backgroundColor = UIColor.PrimaryColors.Button.blue
    }
}
