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

class ChoosingThemeView: UIView {
    // MARK: - Init components
    private let title = UILabel()

    var components =  [(UIButton(), UILabel()),
                    (UIButton(), UILabel()),
                     (UIButton(), UILabel())
                      ]
    var labelText = ["Светлая", "Автоматически", "Темная"]

    override init(frame: CGRect) {
        super.init(frame: frame)
        for (button, label) in components {
            self.addSubview(button)
            self.addSubview(label)
        }
        self.addSubview(title)
        setTipAppearance()
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
}

// MARK: - Internal methods
extension ChoosingThemeView: ThemeViewOutput {
    func getSize() -> CGFloat {
        ThemeTitle.marginTop + ThemeTitle.height + Button.marginTop
        + Button.size + LabelUnderButton.marginTop + LabelUnderButton.height
    }
}

// MARK: - Private methods
private extension ChoosingThemeView {
    func setTipAppearance() {
        title.text = "Тема оформления"
        title.textAlignment = .center
        for (index, (button, label)) in components.enumerated() {
            configureCircularButton(button: button, isActive: false)
            configureLabel(label: label, index: index)
        }
        switchButtonState(button: (components.first?.0)!, active: true)
    }

    func configureCircularButton(button: UIButton, isActive: Bool) {
        button.layer.borderColor = UIColor.blue.cgColor
        button.layer.borderWidth = 3.5
        button.layer.cornerRadius = Button.size / 2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(themeButtonTapped(_:)), for: .touchUpInside)
    }

    @objc func themeButtonTapped(_ sender: UIButton) {
        guard let currentStateButton = components.map({$0.0}).first(where: { $0.isSelected }) else { return }
        guard let newStateButton = components.map({$0.0}).first(where: { $0 == sender }) else { return }
        switchButtonState(button: currentStateButton, active: false)
        switchButtonState(button: newStateButton, active: true,
                          index: components.map({$0.0}).firstIndex(of: newStateButton)!)
    }

    func switchButtonState(button: UIButton, active: Bool, index: Int = 0) {
        let color: UIColor = active ? .blue : .white
        button.isSelected = active
        button.backgroundColor = color
        if active {
            switch index {
            case 0:
                Color.systemMode = .lightMode
            case 1:
                Color.systemMode = .autoMode
            case 2:
                Color.systemMode = .darkMode
            default:
                break
            }
        }
    }

    func configureLabel(label: UILabel, index: Int) {
        label.text = labelText[index]
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
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
        static let height: CGFloat = 10
    }
}
