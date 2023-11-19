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
    private let wordsInProgressLabel: UILabel = UILabel()
    private let adviceLabel: UILabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        [backgroundView, progressView, totalWordsLabel, wordsInProgressLabel, adviceLabel].forEach {
            self.addSubview($0)
        }
        setVisualAppearance()
        setBackgroundView()
        setProgressView()
        setWordsInProgressLabel()
        setTotalWordsLabel()
        setAdviceLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - open methods
extension ProgressView {
    func setupAllWords(count: Int) {
        totalWordsLabel.text = String(count)
    }

    func setupWordsInProgress(count: Int) {
        wordsInProgressLabel.text = String(count)
    }
}

// MARK: - private methods
private extension ProgressView {
    func setVisualAppearance() {
        backgroundView.backgroundColor = .SecondaryColors.ProgressView.customGray
        backgroundView.layer.cornerRadius = ProgressView.Consts.cornerRadius
        progressView.backgroundColor = .SecondaryColors.ProgressView.customGreen
        progressView.layer.cornerRadius = ProgressView.Consts.cornerRadius
        totalWordsLabel.textColor = .black
        wordsInProgressLabel.textColor = .black
        adviceLabel.text = ProgressView.Consts.adviceText
        adviceLabel.textColor = .gray
    }

    func setBackgroundView() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        backgroundView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        backgroundView.heightAnchor.constraint(equalToConstant: UIConstants.BackgroundView.height).isActive = true
    }

    func setProgressView() {
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        progressView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        progressView.widthAnchor.constraint(equalTo: self.widthAnchor,
                                            multiplier: 0.5).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: UIConstants.ProgressView.height).isActive = true
    }

    func setWordsInProgressLabel() {
        wordsInProgressLabel.translatesAutoresizingMaskIntoConstraints = false
        wordsInProgressLabel.topAnchor.constraint(equalTo: backgroundView.bottomAnchor,
                                                  constant: 3).isActive = true
        wordsInProgressLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant:
                                                        UIConstants.WordsInProgressLabel.leading).isActive = true
        wordsInProgressLabel.widthAnchor.constraint(equalToConstant:
                                                        UIConstants.WordsInProgressLabel.width).isActive = true
        wordsInProgressLabel.sizeToFit()
    }

    func setTotalWordsLabel() {
        totalWordsLabel.translatesAutoresizingMaskIntoConstraints = false
        totalWordsLabel.topAnchor.constraint(equalTo: backgroundView.bottomAnchor,
                                             constant: UIConstants.TotalWordsLabel.top).isActive = true
        totalWordsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                  constant: -UIConstants.TotalWordsLabel.trailing).isActive = true
        totalWordsLabel.widthAnchor.constraint(equalToConstant: UIConstants.TotalWordsLabel.width).isActive = true
        totalWordsLabel.sizeToFit()
    }

    func setAdviceLabel() {
        adviceLabel.translatesAutoresizingMaskIntoConstraints = false
        adviceLabel.topAnchor.constraint(equalTo: wordsInProgressLabel.bottomAnchor,
                                         constant: UIConstants.AdviceLabel.top).isActive = true
        adviceLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        adviceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        adviceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        adviceLabel.sizeToFit()
    }
}

// MARK: - Constants
// swiftlint:disable nesting
private extension ProgressView {
    struct Consts {
        static let adviceText: String = "Чтобы продолжить учить слова нажмите на прогресс"
        static let cornerRadius: CGFloat = 5
    }

    struct UIConstants {
        struct BackgroundView {
            static let height: CGFloat = 10.0
        }

        struct ProgressView {
            static let height: CGFloat = 10.0
        }

        struct WordsInProgressLabel {
            static let leading: CGFloat = 155.0
            static let width: CGFloat = 45
        }

        struct TotalWordsLabel {
            static let top: CGFloat = 3.0
            static let trailing: CGFloat = 10.0
            static let width: CGFloat = 45.0
        }

        struct AdviceLabel {
            static let top: CGFloat = 5.0
        }
    }
}
// swiftlint:enable nesting
