//
//  ProfileViewController.swift
//  easyLanguage
//
//  Created by Арсений Чистяков on 22.11.2023.
//  Экран профиля пользователя

import UIKit

final class ProfileViewController: CustomViewController {
    // MARK: - init views
    private let scrollView = UIScrollView()

    private let labelUnderTextField = UILabel()
    private let userInformationView = UserInformationView()
    private let progressView = ProgressView()
    private let choosingThemeView = ChoosingThemeView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Профиль"
        view.addSubview(scrollView)
        setScrollView()
        [userInformationView, progressView, labelUnderTextField, choosingThemeView].forEach {
            scrollView.addSubview($0)
        }
        setAppearance()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUserInformationView()
        setLabelUnderTextField()
        setChoosingTheme()
        setProgressView()
    }
}

// MARK: - private methods
private extension ProfileViewController {
    func setAppearance() {
        progressView.setupWordsInProgress(count: 60)
        progressView.setupAllWords(count: 120)
        labelUnderTextField.text = "Укажите имя и, если хотите, добавьте фотографию для Вашего профиля"
        labelUnderTextField.textColor = UIColor.gray
        labelUnderTextField.font = UIFont.systemFont(ofSize: 12)
        labelUnderTextField.numberOfLines = 0
        labelUnderTextField.lineBreakMode = .byWordWrapping
    }

    // MARK: - layouts
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
                                            constant: Progress.marginRight).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: Progress.height).isActive = true
    }

    func setChoosingTheme() {
        choosingThemeView.translatesAutoresizingMaskIntoConstraints = false
        choosingThemeView.topAnchor.constraint(equalTo: progressView.bottomAnchor).isActive = true
        choosingThemeView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        choosingThemeView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        choosingThemeView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        choosingThemeView.heightAnchor.constraint(equalToConstant: choosingThemeView.getSize()).isActive = true
    }
}

// MARK: - structures
private extension ProfileViewController {
    struct LabelUnderTextField {
        static let text: String = "Укажите имя и, если хотите, добавьте фотографию для Вашего профиля"
        static let height: CGFloat = 30
        static let marginTop: CGFloat = 3
        static let marginLeft: CGFloat = 25
        static let marginRight: CGFloat = -20
    }

    struct Progress {
        static let wordsInProgress: CGFloat = 60
        static let allWords: CGFloat = 60
        static let height: CGFloat = 60
        static let marginTop: CGFloat = 35
        static let marginLeft: CGFloat = 20
        static let marginRight: CGFloat = -20
    }
}
