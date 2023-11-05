//
//  ProgressView.swift
//  easyLanguage
//
//  Created by Grigoriy on 24.10.2023.
//

import UIKit

final class ProgressView: UIView {
    private let backgroundView: UIView = UIView()
    private let progressView: UIView = UIView()
    private let totalWordsLabel: UILabel = UILabel()
    private let halfWordsLabel: UILabel = UILabel()
    private let adviceLabel: UILabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        [backgroundView, progressView, totalWordsLabel, halfWordsLabel, adviceLabel].forEach {
            self.addSubview($0)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - life circle
extension ProgressView {
    override func layoutSubviews() {
        super.layoutSubviews()

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        backgroundView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        backgroundView.heightAnchor.constraint(equalToConstant: 10).isActive = true

        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        progressView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        progressView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 10).isActive = true

        halfWordsLabel.translatesAutoresizingMaskIntoConstraints = false
        halfWordsLabel.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 3).isActive = true
        halfWordsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 155).isActive = true
        halfWordsLabel.widthAnchor.constraint(equalToConstant: 45).isActive = true
        halfWordsLabel.sizeToFit()

        totalWordsLabel.translatesAutoresizingMaskIntoConstraints = false
        totalWordsLabel.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 3).isActive = true
        totalWordsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        totalWordsLabel.widthAnchor.constraint(equalToConstant: 45).isActive = true
        totalWordsLabel.sizeToFit()

        adviceLabel.translatesAutoresizingMaskIntoConstraints = false
        adviceLabel.topAnchor.constraint(equalTo: halfWordsLabel.bottomAnchor, constant: 5).isActive = true
        adviceLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        adviceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        adviceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        adviceLabel.sizeToFit()
    }
}

// MARK: - open methods
extension ProgressView {
    func setupCountOfWords(with count: Int) {
        halfWordsLabel.text = String(count / 2)
        totalWordsLabel.text = String(count)
    }
}

// MARK: - private methods
private extension ProgressView {
    func setup() {
        backgroundView.backgroundColor = .SecondaryColors.ProgressView.customGray
        progressView.backgroundColor = .SecondaryColors.ProgressView.customGreen
        adviceLabel.text = ProgressView.Consts.adviceText
        halfWordsLabel.textColor = .black
        totalWordsLabel.textColor = .black
        adviceLabel.textColor = .gray
        backgroundView.layer.cornerRadius = ProgressView.Consts.cornerRadius
        progressView.layer.cornerRadius = ProgressView.Consts.cornerRadius
    }
}

private extension ProgressView {
    struct Consts {
        static let adviceText: String = "Чтобы продолжить учить слова нажмите на прогресс"
        static let cornerRadius: CGFloat = 5
    }
}
