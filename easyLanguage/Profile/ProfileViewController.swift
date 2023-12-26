//
//  ProfileViewController.swift
//  easyLanguage
//
//  Created by Арсений Чистяков on 22.11.2023.
//  Экран профиля пользователя

import UIKit

final class ProfileViewController: CustomViewController {
    // MARK: - Init views

    private let themeViewOutput: ThemeViewOutput
    private let userInformationViewOutput: UserInformationViewOutput

    private let scrollView = UIScrollView()

    private let userInformationView = UserInformationView()
    private let labelUnderTextField = UILabel()
    private let progressView = ProgressView()
    private let choosingThemeView = ChoosingThemeView()
    private let getOutButton = UIButton()

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
        view.backgroundColor = .PrimaryColors.Background.background
        title = "Профиль"
        view.addSubview(scrollView)
        setScrollView()
        [userInformationView, progressView, labelUnderTextField, choosingThemeView, getOutButton].forEach {
            scrollView.addSubview($0)
        }
        setTipAppearance()
        setUserInformationView()
        setLabelUnderTextField()
        setProgressView()
        setChoosingTheme()
        setGetOutButton()
    }
}

// MARK: - Private methods
private extension ProfileViewController {
    func setTipAppearance() {
        setWordsInProgressLabel()
        labelUnderTextField.text = "Укажите имя и, если хотите, добавьте фотографию для Вашего профиля"
        labelUnderTextField.textColor = UIColor.gray
        labelUnderTextField.font = UIFont.systemFont(ofSize: 12)
        labelUnderTextField.numberOfLines = 0
        labelUnderTextField.lineBreakMode = .byWordWrapping
        getOutButton.setTitle("Выйти из аккаунта", for: .normal)
        getOutButton.setTitleColor(UIColor.red, for: .normal)
        getOutButton.addTarget(self, action: #selector(didTapGetOutButton), for: .touchUpInside)
    }
    func setWordsInProgressLabel() {
        progressView.setupWordsInProgress(count: 60)
        progressView.setupAllLearnedWords(count: 120)
    }
    @objc
    func didTapGetOutButton() {
        let alertController = UIAlertController(title: "Выход из аккаунта",
            message: "Вы уверены, что хотите выйти из аккаунта?", preferredStyle: .alert)
        let getOutAction = UIAlertAction(title: "Выйти", style: .destructive) {_ in
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .default) {_ in
        }
        alertController.addAction(cancelAction)
        alertController.addAction(getOutAction)
        self.present(alertController, animated: true)
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
                                                 constant: LabelUnderTextField.marginTop).isActive = true
        labelUnderTextField.leftAnchor.constraint(equalTo: scrollView.leftAnchor,
                                                  constant: LabelUnderTextField.marginLeft).isActive = true
        labelUnderTextField.rightAnchor.constraint(equalTo: userInformationView.rightAnchor,
                                                   constant: LabelUnderTextField.marginRight).isActive = true
        labelUnderTextField.heightAnchor.constraint(equalToConstant: LabelUnderTextField.height).isActive = true
    }

    func setProgressView() {
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.topAnchor.constraint(equalTo:
                                            labelUnderTextField.bottomAnchor,
                                          constant: Progress.marginTop).isActive = true
        progressView.leftAnchor.constraint(equalTo: scrollView.leftAnchor,
                                           constant: Progress.marginLeft).isActive = true
        progressView.rightAnchor.constraint(equalTo: scrollView.rightAnchor,
                                            constant: -Progress.marginLeft).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: Progress.height).isActive = true
    }

    func setChoosingTheme() {
        choosingThemeView.translatesAutoresizingMaskIntoConstraints = false
        choosingThemeView.topAnchor.constraint(equalTo: progressView.bottomAnchor).isActive = true
        choosingThemeView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        choosingThemeView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        choosingThemeView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        choosingThemeView.heightAnchor.constraint(equalToConstant: themeViewOutput.getSize()).isActive = true
    }
    func setGetOutButton() {
        getOutButton.translatesAutoresizingMaskIntoConstraints = false
        getOutButton.topAnchor.constraint(equalTo:
                    choosingThemeView.bottomAnchor, constant: LogOutButton.marginTop).isActive = true
        getOutButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    }
}

// MARK: - Constants
private extension ProfileViewController {
    struct LabelUnderTextField {
        static let height: CGFloat = 30
        static let marginTop: CGFloat = 3
        static let marginLeft: CGFloat = 25
        static let marginRight: CGFloat = -20
    }

    struct Progress {
        static let height: CGFloat = 60
        static let marginTop: CGFloat = 35
        static let marginLeft: CGFloat = 20
    }
    struct LogOutButton {
        static let marginTop: CGFloat = 35
    }
}
