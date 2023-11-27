//
//  ProfileViewController.swift
//  easyLanguage
//
//  Created by Арсений Чистяков on 22.11.2023.
//  Экран профиля пользователя

import UIKit

//protocol ProgressSetup {
//    func setupAllLeanedWords()
//    func setupWordsInProgress()
//}

final class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    
    private let line = UIView()
    private let firstNameBackgroundView = UIView()
    private let lastNameBackgroundView = UIView()
    private let imageView = UIImageView()
    private let firstNameTextField = UITextField()
    private let lastNameTextField = UITextField()
    private let firstNameLabel = UILabel()
    private var lastNameLabel = UILabel()
    private let labelUnderTextField = UILabel()
    private let labelTheme = UILabel()
    private let progressView = ProgressView()
    private let scrollView = UIScrollView()
    
    let lightThemeButton = UIButton()
    let darkThemeButton = UIButton()
    let automaticThemeButton = UIButton()
    let lightThemeLabel = UILabel()
    let darkThemeLabel = UILabel()
    let automaticThemeLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Профиль"
        
        view.addSubview(scrollView)
        setScrollView()
        
        [firstNameBackgroundView, lastNameBackgroundView].forEach {
            scrollView.addSubview($0)
        }
        
        [firstNameBackgroundView, lastNameBackgroundView].forEach {
            $0.layer.cornerRadius = 10
            $0.layer.borderColor = UIColor.tertiarySystemFill.cgColor
            $0.layer.borderWidth = 1
        }
        
        firstNameLabel.text = "Арсений"
        lastNameLabel.text = "Чистяков"
        
        firstNameBackgroundView.addSubview(firstNameLabel)
        lastNameBackgroundView.addSubview(lastNameLabel)

        
        scrollView.addSubview(firstNameLabel)
        scrollView.addSubview(firstNameLabel)
        
        line.backgroundColor = .tertiarySystemFill
        view.addSubview(line)
        
        scrollView.addSubview(progressView)
        progressView.setupWordsInProgress(count: 60)
        progressView.setupAllWords(count: 120)
//        setupAllLeanedWords()
//        setupWordsInProgress()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.layer.borderWidth = 2.0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.isUserInteractionEnabled = true
        
        
        if let image = UIImage(named: "ProfileEmptyImage") {
            imageView.image = image
        } else {
            print("Image not found")
        }
        scrollView.addSubview(imageView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(tapGesture)
        
        // MOCKMOCKMOCK
        
//        firstNameTextField.placeholder = "Введите имя"
//        firstNameTextField.borderStyle = .roundedRect
//        firstNameTextField.delegate = self
//        scrollView.addSubview(firstNameTextField)
//        
//        lastNameTextField.placeholder = "Введите фамилию"
//        lastNameTextField.borderStyle = .roundedRect
//        lastNameTextField.delegate = self
////        lastNameTextField.layer.borderColor = UIColor.systemPink.cgColor
//        scrollView.addSubview(lastNameTextField)
        
        
        labelTheme.text = "Тема оформления"
        labelTheme.textAlignment = .center
        scrollView.addSubview(labelTheme)
        
        labelUnderTextField.text = "Укажите имя и, если хотите, добавьте фотографию для Вашего профиля"
        labelUnderTextField.textColor = UIColor.gray
        labelUnderTextField.font = UIFont.systemFont(ofSize: 12)
        labelUnderTextField.numberOfLines = 0
        labelUnderTextField.lineBreakMode = .byWordWrapping
        scrollView.addSubview(labelUnderTextField)
        
        configureCircularButton(lightThemeButton, withImageNamed: "lightThemeCheckbox", color: .blue, isActive: true)
        configureCircularButton(darkThemeButton, withImageNamed: "darkThemeCheckbox", color: .blue, isActive: false)
        configureCircularButton(automaticThemeButton, withImageNamed: "automaticThemeCheckbox", color: .blue, isActive: false)

        configureLabel(lightThemeLabel, withText: "Светлая")
        configureLabel(darkThemeLabel, withText: "Темная")
        configureLabel(automaticThemeLabel, withText: "Автоматически")

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        line.frame = CGRect(x: 0,
                            y: view.safeAreaInsets.top + 5,
                            width: scrollView.bounds.width,
                            height: 2)
        imageView.frame = CGRect(x: (scrollView.bounds.width - 130) / 2,
                                 y: scrollView.bounds.minY + 25,
                                 // y: line.frame.maxY + 20,
                                 width: 130,
                                 height: 130)
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        
        firstNameBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        firstNameBackgroundView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30).isActive = true
        firstNameBackgroundView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
        firstNameBackgroundView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40).isActive = true
        firstNameBackgroundView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        firstNameLabel.translatesAutoresizingMaskIntoConstraints = false
        firstNameLabel.topAnchor.constraint(equalTo: firstNameBackgroundView.topAnchor).isActive = true
        firstNameLabel.leftAnchor.constraint(equalTo: firstNameBackgroundView.leftAnchor, constant: 5).isActive = true
        firstNameLabel.widthAnchor.constraint(equalTo: firstNameBackgroundView.widthAnchor).isActive = true
        firstNameLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        lastNameBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        lastNameBackgroundView.topAnchor.constraint(equalTo: firstNameBackgroundView.bottomAnchor, constant: 5).isActive = true
        lastNameBackgroundView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
        lastNameBackgroundView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40).isActive = true
        lastNameBackgroundView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        lastNameLabel.translatesAutoresizingMaskIntoConstraints = false
        lastNameLabel.topAnchor.constraint(equalTo: lastNameBackgroundView.topAnchor).isActive = true
        lastNameLabel.leftAnchor.constraint(equalTo: lastNameBackgroundView.leftAnchor, constant: 5).isActive = true
        lastNameLabel.widthAnchor.constraint(equalTo: lastNameBackgroundView.widthAnchor).isActive = true
        lastNameLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        
//        lastNameLabel.frame =
//        CGRect(x: 20, y: Int(firstNameLabel.bounds.maxY + imageView.frame.maxY) + 35,
//               width: Int(scrollView.bounds.width) - 40, height: 35)
        
        labelUnderTextField.translatesAutoresizingMaskIntoConstraints = false
        labelUnderTextField.topAnchor.constraint(equalTo: lastNameBackgroundView.bottomAnchor, constant: 3).isActive = true
        labelUnderTextField.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 25).isActive = true
        labelUnderTextField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40).isActive = true
        labelUnderTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
//        labelUnderTextField.frame = CGRect(x: 25, y: Int(lastNameBackgroundView.frame.maxY) + 3, width: Int(scrollView.bounds.width) - 40, height: 30)
        
        labelTheme.translatesAutoresizingMaskIntoConstraints = false
        
        labelTheme.frame = CGRect(x: 0, y: progressView.frame.maxY + 25, width: scrollView.bounds.width, height: 30)
        
        
        setProgressView()
        arrangeViews()
    }
    @objc func imageTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
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
    
    func setScrollView(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    func setProgressView() {
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.topAnchor.constraint(equalTo: labelUnderTextField.topAnchor,
                                          constant: 65).isActive = true
        progressView.leftAnchor.constraint(equalTo: scrollView.leftAnchor,
                                           constant: 20).isActive = true
        progressView.rightAnchor.constraint(equalTo: scrollView.rightAnchor,
                                            constant: -20).isActive = true
        progressView.widthAnchor.constraint(equalTo: scrollView.widthAnchor,
                                            constant: -40).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    private func configureCircularButton(_ button: UIButton, withImageNamed imageName: String, color: UIColor, isActive: Bool) {
            button.setImage(UIImage(named: imageName), for: .normal)
            button.layer.borderColor = color.cgColor
            button.layer.borderWidth = 3.5
            button.layer.cornerRadius = button.frame.size.width / 2
            button.clipsToBounds = true
            button.addTarget(self, action: #selector(themeButtonTapped(_:)), for: .touchUpInside)
        if isActive{
            button.backgroundColor = color
        }
        }
    private func configureLabel(_ label: UILabel, withText text: String) {
        label.text = text
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        label.sizeToFit()
    }

    private func arrangeViews() {
    let buttonSpacing: CGFloat = 74
    let buttonSize: CGSize = CGSize(width: 30, height: 30)
        
        
    lightThemeButton.frame = CGRect(origin: CGPoint(x: buttonSpacing, y: labelTheme.frame.maxY + 20), size: buttonSize)
    automaticThemeButton.frame = CGRect(origin: CGPoint(x: lightThemeButton.frame.maxX + buttonSpacing, y: lightThemeButton.frame.minY), size: buttonSize)
    darkThemeButton.frame = CGRect(origin: CGPoint(x: automaticThemeButton.frame.maxX + buttonSpacing, y: lightThemeButton.frame.minY), size: buttonSize)
        
    lightThemeButton.layer.cornerRadius = buttonSize.width / 2
    darkThemeButton.layer.cornerRadius = buttonSize.width / 2
    automaticThemeButton.layer.cornerRadius = buttonSize.width / 2

    lightThemeLabel.frame = CGRect(x: lightThemeButton.frame.minX, y: lightThemeButton.frame.maxY + 5, width: lightThemeLabel.bounds.width, height: 20)
    darkThemeLabel.frame = CGRect(x: darkThemeButton.frame.minX, y: darkThemeButton.frame.maxY + 5, width: darkThemeLabel.bounds.width, height: 20)
    automaticThemeLabel.frame = CGRect(x: automaticThemeButton.frame.minX, y: automaticThemeButton.frame.maxY + 5, width: automaticThemeLabel.bounds.width, height: 20)
        
    lightThemeLabel.center.x = lightThemeButton.center.x
    darkThemeLabel.center.x = darkThemeButton.center.x
    automaticThemeLabel.center.x = automaticThemeButton.center.x
        
    scrollView.addSubview(lightThemeLabel)
    scrollView.addSubview(darkThemeLabel)
    scrollView.addSubview(automaticThemeLabel)
    
    scrollView.addSubview(lightThemeButton)
    scrollView.addSubview(darkThemeButton)
    scrollView.addSubview(automaticThemeButton)

    }
    @objc private func themeButtonTapped(_ sender: UIButton) {
            // Обработка выбора темы
            switch sender {
            case lightThemeButton:
                lightThemeButton.backgroundColor = .blue
                darkThemeButton.backgroundColor = .white
                automaticThemeButton.backgroundColor = .white
                print("Выбрана светлая тема")
            case darkThemeButton:
                lightThemeButton.backgroundColor = .white
                darkThemeButton.backgroundColor = .blue
                automaticThemeButton.backgroundColor = .white
                print("Выбрана темная тема")
            case automaticThemeButton:
                lightThemeButton.backgroundColor = .white
                darkThemeButton.backgroundColor = .white
                automaticThemeButton.backgroundColor = .blue
                print("Выбрана автоматическая тема")
            default:
                break
            }
        }

//extension ProfileViewController: ProgressSetup {
//        func setupAllLeanedWords() {
//            progressView.setupAllWords(count: 120) // должна с бека сумма всех слов приходить
//        }
//
//        func setupWordsInProgress() {
//            progressView.setupWordsInProgress(count: 60)
//        }
//    }
}

