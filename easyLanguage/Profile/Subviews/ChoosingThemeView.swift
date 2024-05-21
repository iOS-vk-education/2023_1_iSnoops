//
//  ChoosingThemeView.swift
//  easyLanguage
//
//  Created by Арсений Чистяков on 10.12.2023.
//  View с выбором темы

import UIKit

protocol ThemeViewOutput {
    func getSize() -> CGFloat
}

class ChoosingThemeView: UIView, switchAndFindButtonDelegate {

    // MARK: - Init components
    private let title = UILabel()

    var components =  [(UIButton(), UILabel()),
                    (UIButton(), UILabel()),
                     (UIButton(), UILabel())
                      ]

    override init(frame: CGRect) {
        super.init(frame: frame)
        setAppearanseAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setThemeLabel()
        for (index, (button, label)) in components.enumerated() {
            setButton(button: button, index: CGFloat(index))
            setLabel(label: label, button: button)
        }
    }

    func switchAndFindButton(theme: String) {
        var newStateButton = UIButton()
        for (button, label) in components {
            if label.text! == theme {
                switchButtonState(button: button, active: true)
            }
        }
        switchTheme(text: theme)
    }
}
// MARK: - Internal methods
extension ChoosingThemeView: ThemeViewOutput {
    func getSize() -> CGFloat {
        ThemeTitle.marginTop + ThemeTitle.height + Button.marginTop
        + Button.size + LabelUnderButton.marginTop + LabelUnderButton.height
    }
}

// MARK: - set all constraints
private extension ChoosingThemeView {
    func setAppearanseAndConstraints() {
        components = AppColor.SystemMode.allCases.map {
            let label = UILabel()
            label.text = $0.description()
            return (UIButton(), label)
        }
        for (button, label) in components {
            self.addSubview(button)
            self.addSubview(label)
        }
        self.addSubview(title)
        setTipAppearance()
    }
}

// MARK: - Private methods
private extension ChoosingThemeView {
    func setTipAppearance() {
        title.text = NSLocalizedString("themeTitle", comment: "")
        title.textAlignment = .center
        for (button, label) in components {
            configureCircularButton(button: button)
            configureLabel(label: label)
        }
        switchAndFindButton(theme: UserDefaults.standard.string(forKey: "selectedTheme") ?? "")
    }

    func configureCircularButton(button: UIButton) {
        button.layer.borderColor = UIColor.blue.cgColor
        button.layer.borderWidth = 3.5
        button.layer.cornerRadius = Button.size / 2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(themeButtonTapped(_:)), for: .touchUpInside)
    }

    @objc func themeButtonTapped(_ sender: UIButton) {
        guard let currentStateButton = components.map({$0.0}).first(where: { $0.isSelected }) else { return }
        guard let newStateButton = components.map({$0.0}).first(where: { $0 == sender }) else { return }
        let label = components[components.map({$0.0}).firstIndex(of: newStateButton)!].1
        switchButtonState(button: currentStateButton, active: false)
        switchButtonState(button: newStateButton, active: true)
        switchTheme(text: label.text!)
    }

    func switchButtonState(button: UIButton, active: Bool) {
        let color: UIColor = active ? .blue : .PrimaryColors.Background.background
        button.isSelected = active
        button.backgroundColor = color
    }

    func switchTheme(text: String) {
        switch text {
        case NSLocalizedString("lightThemeLabel", comment: ""):
            UserDefaults.standard.set(NSLocalizedString("lightThemeLabel", comment: ""), forKey: "selectedTheme")
            AppColor.systemMode = .lightMode
        case NSLocalizedString("autoThemeLabel", comment: ""):
            UserDefaults.standard.set(NSLocalizedString("autoThemeLabel", comment: ""), forKey: "selectedTheme")
            AppColor.systemMode = .autoMode
        case NSLocalizedString("darkThemeLabel", comment: ""):
            UserDefaults.standard.set(NSLocalizedString("darkThemeLabel", comment: ""), forKey: "selectedTheme")
            AppColor.systemMode = .darkMode
        default:
            UserDefaults.standard.set(NSLocalizedString("lightThemeLabel", comment: ""), forKey: "selectedTheme")
            AppColor.systemMode = .lightMode
        }
    }

    func configureLabel(label: UILabel) {
        label.textAlignment = .center
        label.textColor = .Profile.ButtonLabel.color
        label.font = TextStyle.bodyMedium.font
        label.sizeToFit()
    }

    func getButtonSpacing() -> CGFloat {
        (self.bounds.width - 3 * Button.size) / 4
    }
}

private extension ChoosingThemeView {
    // MARK: - Layout
    func setThemeLabel() {
        title.translatesAutoresizingMaskIntoConstraints = false
        title.topAnchor.constraint(equalTo: self.topAnchor, constant: ThemeTitle.marginTop).isActive = true
        title.leftAnchor.constraint(equalTo: self.leftAnchor, constant: ThemeTitle.marginLeft).isActive = true
        title.widthAnchor.constraint(equalTo: self.widthAnchor, constant: ThemeTitle.marginRight).isActive = true
        title.heightAnchor.constraint(equalToConstant: ThemeTitle.height).isActive = true
    }

    func setButton(button: UIButton, index: CGFloat) {
        let leftConstant = (getButtonSpacing() * (index + 1.0) + index * Button.size)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: title.bottomAnchor,
                                    constant: Button.marginTop).isActive = true
        button.leftAnchor.constraint(equalTo: self.leftAnchor, constant:
                                        leftConstant).isActive = true
        button.widthAnchor.constraint(equalToConstant: Button.size).isActive = true
        button.heightAnchor.constraint(equalToConstant: Button.size).isActive = true
    }

    func setLabel(label: UILabel, button: UIButton) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: button.bottomAnchor,
                                   constant: LabelUnderButton.marginTop).isActive = true
        label.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: LabelUnderButton.height).isActive = true
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
        static let height: CGFloat = 20
    }
}
