//
//  ProgressView.swift
//  easyLanguage
//
//  Created by Grigoriy on 24.10.2023.
//

import UIKit

final class ProgressView: UIView {
    private let progressView: UIProgressView = UIProgressView()
    private let adviceLabel: UILabel = UILabel()
    private let percentageLabel: UILabel = UILabel()
    private var totalWords: Int?
    private var learnedWords: Int?

    override init(frame: CGRect) {
        super.init(frame: frame)

        [progressView, adviceLabel, percentageLabel].forEach {
            addSubview($0)
        }

        setVisualAppearance()
        setProgressView()
        setAdviceLabel()
        setPercentageLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Internal

extension ProgressView {
    func setupAllLearnedWords(count: Int) {
        totalWords = count
    }

    func setupWordsInProgress(count: Int) {
        learnedWords = count
    }

    func setProgress() {
        guard let allLearnedWords = totalWords,
              let wordsInProgress = learnedWords
        else {
            return
        }

        guard allLearnedWords > 0 else {
            progressView.progress = 0.0
            return
        }

        progressView.progress = Float(wordsInProgress) / Float(allLearnedWords)
        setPercentageLabelValue()
    }
}

// MARK: - Private methods
private extension ProgressView {
    func setVisualAppearance() {
        setProgressAppearance()
        setAdviceLabelAppearance()
        setPercentageLabelAppearance()
    }

    func setProgressAppearance() {
        progressView.trackTintColor = .SecondaryColors.ProgressView.gray
        progressView.tintColor = .SecondaryColors.ProgressView.green
        progressView.layer.cornerRadius = ProgressView.Consts.cornerRadius
        progressView.clipsToBounds = true

        if let sublayers = progressView.layer.sublayers, sublayers.count > 1 {
            sublayers[1].cornerRadius = ProgressView.Consts.cornerRadius
        }

        if progressView.subviews.count > 1 {
            progressView.subviews[1].clipsToBounds = true
        }
    }

    func setAdviceLabelAppearance() {
        adviceLabel.text =  NSLocalizedString("progressAdvice", comment: "")
        adviceLabel.font = TextStyle.bodySmall.font
        adviceLabel.textColor = .gray
    }

    func setPercentageLabelAppearance() {
        percentageLabel.font = TextStyle.bodyMedium.font
        percentageLabel.textAlignment = .center
        percentageLabel.textColor = .Catalog.Green.categoryText
    }

    func setProgressView() {
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        progressView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        progressView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: Consts.height).isActive = true
    }

    func setAdviceLabel() {
        adviceLabel.translatesAutoresizingMaskIntoConstraints = false
        adviceLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 6).isActive = true
        adviceLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        adviceLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        adviceLabel.sizeToFit()
    }

    func setPercentageLabel() {
        percentageLabel.translatesAutoresizingMaskIntoConstraints = false
        percentageLabel.centerXAnchor.constraint(equalTo: progressView.centerXAnchor).isActive = true
        percentageLabel.centerYAnchor.constraint(equalTo: progressView.centerYAnchor).isActive = true
    }

    func setPercentageLabelValue() {
        guard let wordsInProgress = learnedWords,
              let allLearnedWords = totalWords
        else {
            return
        }

        let percentage = Int((Float(wordsInProgress) / Float(allLearnedWords)) * 100)
        percentageLabel.text = "\(percentage)%"
    }
}

// MARK: - Constants
private extension ProgressView {
    struct Consts {
        static let height: CGFloat = 20
        static let cornerRadius: CGFloat = 8
    }
}
