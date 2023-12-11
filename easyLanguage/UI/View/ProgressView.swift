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
    private let halfProgressLabel: UILabel = UILabel()
    private let zeroProgressLabel: UILabel = UILabel()
    private let adviceLabel: UILabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        [backgroundView, progressView, zeroProgressLabel, totalWordsLabel, halfProgressLabel, adviceLabel].forEach {
            addSubview($0)
        }

        setVisualAppearance()
        setBackgroundView()
        setProgressView()
        setWordsInProgressLabel()
        setTotalWordsLabel()
        setAdviceLabel()
        setZeroProgressLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - open methods
extension ProgressView {
    func setupAllWords(count: Int) {
        totalWordsLabel.text = String(count)
        halfProgressLabel.text = String(count / 2)
    }

    func setupWordsInProgress(count: Int) {
        guard let totalWordsCount = Int(totalWordsLabel.text ?? "0") else {
            return
        }
        let progressPercentage = CGFloat(count) / CGFloat(totalWordsCount)

        progressView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: progressPercentage).isActive = true
    }
}

// MARK: - private methods
private extension ProgressView {
    func setVisualAppearance() {
        setBackgroundAppearance()
        setProgressAppearance()
        setTotalWordsLabelAppearance()
        setHalfProgressLabelAppearance()
        setAdviceLabelAppearance()
        setZeroProgressLabelAppearance()
    }

    func setBackgroundAppearance() {
        backgroundView.backgroundColor = .SecondaryColors.ProgressView.gray
        backgroundView.layer.cornerRadius = ProgressView.Consts.cornerRadius
    }

    func setProgressAppearance() {
        progressView.backgroundColor = .SecondaryColors.ProgressView.green
        progressView.layer.cornerRadius = ProgressView.Consts.cornerRadius
    }

    func setTotalWordsLabelAppearance() {
        totalWordsLabel.textColor = .black
    }

    func setHalfProgressLabelAppearance() {
        halfProgressLabel.textColor = .black
        halfProgressLabel.textAlignment = .center
    }

    func setAdviceLabelAppearance() {
        adviceLabel.text = ProgressView.Consts.adviceText
        adviceLabel.textColor = .gray
    }

    func setZeroProgressLabelAppearance() {
        zeroProgressLabel.text = "0"
    }

    func setBackgroundView() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        backgroundView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        backgroundView.heightAnchor.constraint(equalToConstant: UIConstants.ProgressLineView.height).isActive = true
    }

    func setProgressView() {
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        progressView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: UIConstants.ProgressLineView.height).isActive = true
    }

    func setZeroProgressLabel() {
        zeroProgressLabel.translatesAutoresizingMaskIntoConstraints = false
        zeroProgressLabel.topAnchor.constraint(equalTo: backgroundView.bottomAnchor,
                                               constant: UIConstants.CountOfWordsLabel.top).isActive = true
        zeroProgressLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: UIConstants.ZeroProgressLabel.left).isActive = true
        zeroProgressLabel.widthAnchor.constraint(equalToConstant:
                                               UIConstants.CountOfWordsLabel.width).isActive = true
        zeroProgressLabel.sizeToFit()
    }

    func setWordsInProgressLabel() {
        halfProgressLabel.translatesAutoresizingMaskIntoConstraints = false
        halfProgressLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor,
                                               constant: UIConstants.CountOfWordsLabel.top).isActive = true
        halfProgressLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        halfProgressLabel.widthAnchor.constraint(equalToConstant:
                                               UIConstants.CountOfWordsLabel.width).isActive = true
        halfProgressLabel.sizeToFit()
    }

    func setTotalWordsLabel() {
        totalWordsLabel.translatesAutoresizingMaskIntoConstraints = false
        totalWordsLabel.topAnchor.constraint(equalTo: backgroundView.bottomAnchor,
                                               constant: UIConstants.CountOfWordsLabel.top).isActive = true
        totalWordsLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        totalWordsLabel.widthAnchor.constraint(equalToConstant:
                                               UIConstants.CountOfWordsLabel.width).isActive = true
        totalWordsLabel.sizeToFit()
    }

    func setAdviceLabel() {
        adviceLabel.translatesAutoresizingMaskIntoConstraints = false
        adviceLabel.topAnchor.constraint(equalTo: halfProgressLabel.bottomAnchor,
                                         constant: UIConstants.AdviceLabel.top).isActive = true
        adviceLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        adviceLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
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
        struct CountOfWordsLabel {
            static let top: CGFloat = 3.0
            static let width: CGFloat = 45.0
        }

        struct ZeroProgressLabel {
            static let left: CGFloat = 8.0
        }

        struct ProgressLineView {
            static let height: CGFloat = 10.0
        }

        struct AdviceLabel {
            static let top: CGFloat = 5.0
        }
    }
}
// swiftlint:enable nesting
