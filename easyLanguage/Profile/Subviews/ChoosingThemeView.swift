//
//  ChoosingThemeView.swift
//  easyLanguage
//
//  Created by Арсений Чистяков on 10.12.2023.
//  View с выбором темы

import UIKit

class ChoosingThemeView: UIView {
    // MARK: - Init labels & buttons
    private let themeLabel = UILabel()
    private let lightThemeButton = UIButton()
    private let darkThemeButton = UIButton()
    private let automaticThemeButton = UIButton()
    private let lightThemeLabel = UILabel()
    private let darkThemeLabel = UILabel()
    private let automaticThemeLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        [themeLabel, lightThemeLabel, automaticThemeLabel,
         darkThemeLabel, lightThemeButton, automaticThemeButton, darkThemeButton].forEach {
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
        setLightThemeButton()
        setAutomaticThemeButton()
        setDarkThemeButton()
        setLightThemeLabel()
        setAutomaticThemeLabel()
        setDarkThemeLabel()
    }
}

// MARK: - Open methods
extension ChoosingThemeView {
    func getSize() -> CGFloat {
        return ThemeLabel.marginTop + ThemeLabel.height + Button.marginTop
        + Button.size + LabelUnderButton.marginTop + LabelUnderButton.height
    }
}

// MARK: - Private methods
private extension ChoosingThemeView {
    func setVisualAppearance() {
        themeLabel.text = ThemeLabel.text
        themeLabel.textAlignment = .center
        configureCircularButton(lightThemeButton, color: .blue, isActive: true)
        configureCircularButton(darkThemeButton, color: .blue, isActive: false)
        configureCircularButton(automaticThemeButton, color: .blue, isActive: false)
        configureLabel(lightThemeLabel, withText: "Светлая")
        configureLabel(darkThemeLabel, withText: "Темная")
        configureLabel(automaticThemeLabel, withText: "Автоматически")
        [lightThemeButton, automaticThemeButton, darkThemeButton].forEach {
            $0.layer.cornerRadius = Button.size / 2
        }
    }

    func configureCircularButton(_ button: UIButton, color: UIColor, isActive: Bool) {
        button.layer.borderColor = color.cgColor
        button.layer.borderWidth = 3.5
        button.layer.cornerRadius = button.frame.size.width / 2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(themeButtonTapped(_:)), for: .touchUpInside)
        if isActive {
            button.backgroundColor = color
        }
    }

    @objc func themeButtonTapped(_ sender: UIButton) {
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
        themeLabel.translatesAutoresizingMaskIntoConstraints = false
        themeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: ThemeLabel.marginTop).isActive = true
        themeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: ThemeLabel.marginLeft).isActive = true
        themeLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: ThemeLabel.marginRight).isActive = true
        themeLabel.heightAnchor.constraint(equalToConstant: ThemeLabel.height).isActive = true
    }

    func setLightThemeButton() {
        lightThemeButton.translatesAutoresizingMaskIntoConstraints = false
        lightThemeButton.topAnchor.constraint(equalTo: themeLabel.bottomAnchor,
                                              constant: Button.marginTop).isActive = true
        lightThemeButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: getButtonSpacing()).isActive = true
        lightThemeButton.widthAnchor.constraint(equalToConstant: Button.size).isActive = true
        lightThemeButton.heightAnchor.constraint(equalToConstant: Button.size).isActive = true
    }

    func setAutomaticThemeButton() {
        automaticThemeButton.translatesAutoresizingMaskIntoConstraints = false
        automaticThemeButton.topAnchor.constraint(equalTo: lightThemeButton.topAnchor).isActive = true
        automaticThemeButton.leftAnchor.constraint(equalTo: lightThemeButton.rightAnchor,
                                                   constant: getButtonSpacing()).isActive = true
        automaticThemeButton.widthAnchor.constraint(equalToConstant: Button.size).isActive = true
        automaticThemeButton.heightAnchor.constraint(equalToConstant: Button.size).isActive = true
    }

    func setDarkThemeButton() {
        darkThemeButton.translatesAutoresizingMaskIntoConstraints = false
        darkThemeButton.topAnchor.constraint(equalTo: lightThemeButton.topAnchor).isActive = true
        darkThemeButton.leftAnchor.constraint(equalTo: automaticThemeButton.rightAnchor,
                                              constant: getButtonSpacing()).isActive = true
        darkThemeButton.widthAnchor.constraint(equalToConstant: Button.size).isActive = true
        darkThemeButton.heightAnchor.constraint(equalToConstant: Button.size).isActive = true
    }

    func setLightThemeLabel() {
        lightThemeLabel.translatesAutoresizingMaskIntoConstraints = false
        lightThemeLabel.topAnchor.constraint(equalTo: lightThemeButton.bottomAnchor,
                                             constant: LabelUnderButton.marginTop).isActive = true
        lightThemeLabel.centerXAnchor.constraint(equalTo: lightThemeButton.centerXAnchor).isActive = true
        lightThemeLabel.heightAnchor.constraint(equalToConstant: LabelUnderButton.height).isActive = true
    }

    func setAutomaticThemeLabel() {
        darkThemeLabel.translatesAutoresizingMaskIntoConstraints = false
        darkThemeLabel.topAnchor.constraint(equalTo: lightThemeButton.bottomAnchor,
                                            constant: LabelUnderButton.marginTop).isActive = true
        darkThemeLabel.centerXAnchor.constraint(equalTo: darkThemeButton.centerXAnchor).isActive = true
        darkThemeLabel.heightAnchor.constraint(equalToConstant: LabelUnderButton.height).isActive = true
    }

    func setDarkThemeLabel() {
        automaticThemeLabel.translatesAutoresizingMaskIntoConstraints = false
        automaticThemeLabel.topAnchor.constraint(equalTo: automaticThemeButton.bottomAnchor,
                                                 constant: LabelUnderButton.marginTop).isActive = true
        automaticThemeLabel.centerXAnchor.constraint(equalTo: automaticThemeButton.centerXAnchor).isActive = true
        automaticThemeLabel.heightAnchor.constraint(equalToConstant: LabelUnderButton.height).isActive = true
    }
}

// MARK: - Constants
private extension ChoosingThemeView {
    struct ThemeLabel {
        static let text: String = "Тема оформления"
        static let marginTop: CGFloat = 30
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
