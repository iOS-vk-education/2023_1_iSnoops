//
//  ChoosingThemeView.swift
//  easyLanguage
//
//  Created by Арсений Чистяков on 10.12.2023.
//  View с выбором темы

import UIKit

class ChoosingThemeView: UIView {
    // MARK: - Init labels & buttons
    private let themeTitle = UILabel()
    private let lightThemeButton = UIButton()
    private let darkThemeButton = UIButton()
    private let systemThemeButton = UIButton()
    private let lightThemeLabel = UILabel()
    private let darkThemeLabel = UILabel()
    private let systemThemeLabel = UILabel()

    var buttons = Array(repeating: UIButton(), count: 3)
    var labels = Array(repeating: UILabel(), count: 3)

    override init(frame: CGRect) {
        super.init(frame: frame)
        for button in buttons {
            self.addSubview(button)
        }
        [themeTitle, lightThemeLabel, systemThemeLabel,
         darkThemeLabel, lightThemeButton, systemThemeButton, darkThemeButton].forEach {
            self.addSubview($0)
        }
        setVisualAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setThemeLabel()
        for index in 0...2 {
            setButton(button: buttons[index], index: CGFloat(index))
            configureCircularButton(buttons[index], color: .blue, isActive: false)
        }
//        for button in buttons {
//            setButton(button: button)
//            configureCircularButton(button, color: .blue, isActive: false)
//        }
//        for index in 0...2 {
//            setButton(button: buttons[index], index: CGFloat(index))
//            configureCircularButton(buttons[index], color: .blue, isActive: false)
//        }
//        setLightThemeButton()
//        setSystemThemeButton()
//        setDarkThemeButton()
        setLightThemeLabel()
        setSystemThemeLabel()
        setDarkThemeLabel()
    }
}

// MARK: - Open methods
extension ChoosingThemeView {
    func getSize() -> CGFloat {
        return ThemeTitle.marginTop + ThemeTitle.height + Button.marginTop
        + Button.size + LabelUnderButton.marginTop + LabelUnderButton.height
    }
}

// MARK: - Private methods
private extension ChoosingThemeView {
    func setVisualAppearance() {
        themeTitle.text = "Тема оформления"
        themeTitle.textAlignment = .center
//        configureCircularButton(lightThemeButton, color: .blue, isActive: true)
//        configureCircularButton(darkThemeButton, color: .blue, isActive: false)
//        configureCircularButton(systemThemeButton, color: .blue, isActive: false)
        configureLabel(lightThemeLabel, withText: "Светлая")
        configureLabel(darkThemeLabel, withText: "Темная")
        configureLabel(systemThemeLabel, withText: "Автоматически")
        [lightThemeButton, systemThemeButton, darkThemeButton].forEach {
            $0.layer.cornerRadius = Button.size / 2
        }
    }

    func configureCircularButton(_ button: UIButton, color: UIColor, isActive: Bool) {
        button.layer.borderColor = color.cgColor
        button.layer.borderWidth = 3.5
        button.layer.cornerRadius = button.frame.size.width / 2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(themeButtonTapped(_:)), for: .touchUpInside)
        switchButtonState(button: button, active: isActive)
    }

//    @objc func themeButtonTapped(_ sender: UIButton) {
//        switch sender {
//        case lightThemeButton:
//            lightThemeButton.backgroundColor = .blue
//            darkThemeButton.backgroundColor = .white
//            systemThemeButton.backgroundColor = .white
//            Color.systemMode = .lightMode
//        case darkThemeButton:
//            lightThemeButton.backgroundColor = .white
//            darkThemeButton.backgroundColor = .blue
//            systemThemeButton.backgroundColor = .white
//            Color.systemMode = .darkMode
//        case systemThemeButton:
//            lightThemeButton.backgroundColor = .white
//            darkThemeButton.backgroundColor = .white
//            systemThemeButton.backgroundColor = .blue
//            Color.systemMode = .autoMode
//        default:
//            break
//        }
//    }
    @objc func themeButtonTapped(_ sender: UIButton) {
        guard let currentStateButton = buttons.first(where: { $0.isSelected }) else { return }
        guard let newStateButton = buttons.first(where: { $0 == sender }) else { return }
        switchButtonState(button: currentStateButton, active: false)
        switchButtonState(button: newStateButton, active: true)
    }

    func switchButtonState(button: UIButton, active: Bool) {
        let color: UIColor = active ? .blue : .white
        button.isSelected = active
        button.backgroundColor = color
    }

    func configureLabel(_ label: UILabel, withText text: String) {
        label.text = text
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        label.sizeToFit()
    }

    func getButtonSpacing() -> CGFloat {
        return (self.bounds.width - 3 * Button.size) / 4
    }

    // MARK: - Layout
    func setThemeLabel() {
        themeTitle.translatesAutoresizingMaskIntoConstraints = false
        themeTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: ThemeTitle.marginTop).isActive = true
        themeTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: ThemeTitle.marginLeft).isActive = true
        themeTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: ThemeTitle.marginRight).isActive = true
        themeTitle.heightAnchor.constraint(equalToConstant: ThemeTitle.height).isActive = true
    }

    func setButton(button: UIButton, index: CGFloat) {
        let leftConstant = (getButtonSpacing() * (index + 1.0) + index * Button.size)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: themeTitle.bottomAnchor,
                                              constant: Button.marginTop).isActive = true
        button.leftAnchor.constraint(equalTo: self.leftAnchor, constant:
        leftConstant).isActive = true
        button.widthAnchor.constraint(equalToConstant: Button.size).isActive = true
        button.heightAnchor.constraint(equalToConstant: Button.size).isActive = true
        print(leftConstant)
    }
//    func setLightThemeButton() {
//        lightThemeButton.translatesAutoresizingMaskIntoConstraints = false
//        lightThemeButton.topAnchor.constraint(equalTo: themeTitle.bottomAnchor,
//                                              constant: Button.marginTop).isActive = true
//        lightThemeButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: getButtonSpacing()).isActive = true
//        lightThemeButton.widthAnchor.constraint(equalToConstant: Button.size).isActive = true
//        lightThemeButton.heightAnchor.constraint(equalToConstant: Button.size).isActive = true
//    }
//
//    func setSystemThemeButton() {
//        systemThemeButton.translatesAutoresizingMaskIntoConstraints = false
//        systemThemeButton.topAnchor.constraint(equalTo: lightThemeButton.topAnchor).isActive = true
//        systemThemeButton.leftAnchor.constraint(equalTo: lightThemeButton.rightAnchor,
//                                                   constant: getButtonSpacing()).isActive = true
//        systemThemeButton.widthAnchor.constraint(equalToConstant: Button.size).isActive = true
//        systemThemeButton.heightAnchor.constraint(equalToConstant: Button.size).isActive = true
//    }
//
//    func setDarkThemeButton() {
//        darkThemeButton.translatesAutoresizingMaskIntoConstraints = false
//        darkThemeButton.topAnchor.constraint(equalTo: lightThemeButton.topAnchor).isActive = true
//        darkThemeButton.leftAnchor.constraint(equalTo: systemThemeButton.rightAnchor,
//                                              constant: getButtonSpacing()).isActive = true
//        darkThemeButton.widthAnchor.constraint(equalToConstant: Button.size).isActive = true
//        darkThemeButton.heightAnchor.constraint(equalToConstant: Button.size).isActive = true
//    }

    func setLightThemeLabel() {
        lightThemeLabel.translatesAutoresizingMaskIntoConstraints = false
        lightThemeLabel.topAnchor.constraint(equalTo: lightThemeButton.bottomAnchor,
                                             constant: LabelUnderButton.marginTop).isActive = true
        lightThemeLabel.centerXAnchor.constraint(equalTo: lightThemeButton.centerXAnchor).isActive = true
        lightThemeLabel.heightAnchor.constraint(equalToConstant: LabelUnderButton.height).isActive = true
    }

    func setDarkThemeLabel() {
        darkThemeLabel.translatesAutoresizingMaskIntoConstraints = false
        darkThemeLabel.topAnchor.constraint(equalTo: lightThemeButton.bottomAnchor,
                                            constant: LabelUnderButton.marginTop).isActive = true
        darkThemeLabel.centerXAnchor.constraint(equalTo: darkThemeButton.centerXAnchor).isActive = true
        darkThemeLabel.heightAnchor.constraint(equalToConstant: LabelUnderButton.height).isActive = true
    }

    func setSystemThemeLabel() {
        systemThemeLabel.translatesAutoresizingMaskIntoConstraints = false
        systemThemeLabel.topAnchor.constraint(equalTo: systemThemeButton.bottomAnchor,
                                                 constant: LabelUnderButton.marginTop).isActive = true
        systemThemeLabel.centerXAnchor.constraint(equalTo: systemThemeButton.centerXAnchor).isActive = true
        systemThemeLabel.heightAnchor.constraint(equalToConstant: LabelUnderButton.height).isActive = true
    }
}

// MARK: - Constants
private extension ChoosingThemeView {
    struct ThemeTitle {
        static let marginTop: CGFloat = 35
        static let marginLeft: CGFloat = 20
        static let marginRight: CGFloat = -40
        static let height: CGFloat = 30
    }

    struct Button {
        static let size: CGFloat = 35
        static let marginTop: CGFloat = 25
    }

    struct LabelUnderButton {
        static let marginTop: CGFloat = 10
        static let height: CGFloat = 10
    }
}
