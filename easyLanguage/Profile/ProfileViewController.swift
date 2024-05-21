//
//  ProfileViewController.swift
//  easyLanguage
//
//  Created by Арсений Чистяков on 22.11.2023.
//  Экран профиля пользователя

import UIKit
import SwiftUI

final class ProfileViewController: CustomViewController, UserInformationViewDelegate {

    // MARK: - Init views

    private let themeViewOutput: ThemeViewOutput
    private let userInformationViewOutput: UserInformationViewOutput

    private let scrollView = UIScrollView()

    private let userInformationView = UserInformationView()
    private let labelUnderTextField = UILabel()
    private let progressView = ProgressView()
    private let choosingThemeView = ChoosingThemeView()
    private let logOutButton = UIButton()
    private let achievementsImageView = UIImageView()

    private let model = ProfileModel()

    private let imagePicker = ImagePicker()

    init(themeViewOutput: ThemeViewOutput, userInformationViewOutput: UserInformationViewOutput) {
        self.themeViewOutput = themeViewOutput
        self.userInformationViewOutput = userInformationViewOutput
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        userInformationView.delegate = self
        setAppearanseAndConstraints()
        Task {
            await loadProfile()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setProgressWords()
    }

    @objc func didTapImage() {
        imagePicker.showImagePicker(with: self) { [weak self] image in
            Task {
                await self?.uploadImage(image: image)
            }
        }
    }
}

// MARK: - Network
private extension ProfileViewController {
    func loadProfile() async {
        do {
            let profile = try await model.loadProfile()
            userInformationView.setTextFields(with: profile)
            guard let imageLink = profile.imageLink else { return }
            userInformationView.setImage(imageLink: imageLink)
        } catch {
            print(error.localizedDescription)
            return
        }
    }

    func setProgressWords() {
        let count = CatalogModel().loadCDProgressView()
        self.progressView.setupAllLearnedWords(count: count.0)
        self.progressView.setupWordsInProgress(count: count.1)
        self.progressView.setProgress()
    }

    func uploadImage(image: UIImage) async {
        do {
            let url = try await model.uploadImage(image: image)
            await self.userInformationView.setImage(imageLink: url.absoluteString)
        } catch {
            print(error.localizedDescription)
            return
        }
    }
}

// MARK: - set all constraints
private extension ProfileViewController {
    private func setAppearanseAndConstraints() {
        view.addSubview(scrollView)
        setScrollView()
        [userInformationView, progressView, labelUnderTextField, choosingThemeView, logOutButton, achievementsImageView].forEach {
            scrollView.addSubview($0)
        }
        setTipAppearance()
        setUserInformationView()
        setLabelUnderTextField()
        setProgressView()
        setChoosingTheme()
        setLogOutButton()
    }
}

// MARK: - Private methods
private extension ProfileViewController {
    func setTipAppearance() {
        view.backgroundColor = .PrimaryColors.Background.background
        title = NSLocalizedString("profileTitle", comment: "")
        setUpLabelUnderTextField()
        setUpLogOutButton()
        setUpAchievementsImage()
    }

    func setUpLabelUnderTextField() {
        labelUnderTextField.text = NSLocalizedString("labelUnderTextFields", comment: "")
        labelUnderTextField.textColor = UIColor.gray
        labelUnderTextField.font = TextStyle.bodySmall.font
        labelUnderTextField.numberOfLines = 0
        labelUnderTextField.lineBreakMode = .byWordWrapping
    }

    func setUpLogOutButton() {
        logOutButton.setTitle(NSLocalizedString("logOutFromAccount", comment: ""), for: .normal)
        logOutButton.setTitleColor(UIColor.red, for: .normal)
        logOutButton.titleLabel?.font = TextStyle.bodyBig.font
        logOutButton.addTarget(self, action: #selector(didTapLogOutButton), for: .touchUpInside)
    }

    func setUpAchievementsImage() {
        achievementsImageView.image = UIImage(systemName: "chart.bar")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapAchievemetsImage))
        achievementsImageView.addGestureRecognizer(tapGesture)
        let imageBarButton = UIBarButtonItem(customView: achievementsImageView)
        navigationItem.rightBarButtonItem = imageBarButton
    }

    @objc
    func didTapLogOutButton() {
        let alertController = UIAlertController(title: NSLocalizedString("alertTitle", comment: ""),
            message: NSLocalizedString("alertQuestion", comment: ""), preferredStyle: .alert)
        let logOutAction = UIAlertAction(title: NSLocalizedString("alertExit", comment: ""), style: .destructive) {_ in
            AuthService.shared.signOut { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
            self.logout()
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("alertCancel", comment: ""), style: .default) {_ in
        }
        alertController.addAction(cancelAction)
        alertController.addAction(logOutAction)
        self.present(alertController, animated: true)
    }

    @objc
    func didTapAchievemetsImage() {
        self.navigationController?.pushViewController(
            UIHostingController(rootView: AchievementStaticsBaseView()),
            animated: true
        )
    }

    func logout() {
        let controller = RegistrationViewController()
        controller.modalPresentationStyle = .fullScreen
        let navigation = UINavigationController(rootViewController: controller)
        guard let window = UIApplication.shared.windows.first else { return }
        window.rootViewController = navigation
        window.makeKeyAndVisible()
    }

    // MARK: - Layouts
    func setScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    func setUserInformationView() {
        userInformationView.translatesAutoresizingMaskIntoConstraints = false
        userInformationView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        userInformationView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        userInformationView.heightAnchor.constraint(equalToConstant: userInformationView.getSize()).isActive = true
        userInformationView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }

    func setLabelUnderTextField() {
        labelUnderTextField.translatesAutoresizingMaskIntoConstraints = false
        labelUnderTextField.topAnchor.constraint(equalTo: userInformationView.bottomAnchor,
                                                 constant: 3).isActive = true
        labelUnderTextField.leftAnchor.constraint(equalTo: scrollView.leftAnchor,
                                                  constant: Constraints.marginLeft).isActive = true
        labelUnderTextField.rightAnchor.constraint(equalTo: userInformationView.rightAnchor,
                                                   constant: -Constraints.marginLeft).isActive = true
        labelUnderTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }

    func setProgressView() {
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.topAnchor.constraint(equalTo:
                                            labelUnderTextField.bottomAnchor,
                                          constant: 30).isActive = true
        progressView.leftAnchor.constraint(equalTo: scrollView.leftAnchor,
                                           constant: Constraints.marginLeft).isActive = true
        progressView.rightAnchor.constraint(equalTo: scrollView.rightAnchor,
                                            constant: -Constraints.marginLeft).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }

    func setChoosingTheme() {
        choosingThemeView.translatesAutoresizingMaskIntoConstraints = false
        choosingThemeView.topAnchor.constraint(equalTo: progressView.bottomAnchor).isActive = true
        choosingThemeView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        choosingThemeView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        choosingThemeView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        choosingThemeView.heightAnchor.constraint(equalToConstant: themeViewOutput.getSize()).isActive = true
    }

    func setLogOutButton() {
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        logOutButton.topAnchor.constraint(equalTo:
                    choosingThemeView.bottomAnchor, constant: 35).isActive = true
        logOutButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    }
}

// MARK: - Constants
private extension ProfileViewController {
    struct Constraints {
        static let marginLeft: CGFloat = 20
    }
}
