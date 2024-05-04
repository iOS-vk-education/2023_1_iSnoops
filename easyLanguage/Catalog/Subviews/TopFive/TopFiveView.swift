//
//  TopFiveView.swift
//  easyLanguage
//
//  Created by Grigoriy on 26.10.2023.
//

import UIKit

final class TopFiveView: UIView {
    private let titleLabel = UILabel()
    private let adviceLabel = UILabel()
    weak var inputTopFiveWords: InputTopFiveWordsDelegate?
    private let topFiveCollectionView = TopFiveCollectionView()

    init(inputTopFiveWords: InputTopFiveWordsDelegate) {
        super.init(frame: .zero)

        self.inputTopFiveWords = inputTopFiveWords
        topFiveCollectionView.setupInputTopFiveWordsDelegate(with: inputTopFiveWords)

        setVisualAppearance()
        [topFiveCollectionView, titleLabel, adviceLabel].forEach {
            addSubview($0)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - life cycle
extension TopFiveView {
    override func layoutSubviews() {
        super.layoutSubviews()
        setTitleLabel()
        setTopFiveCollectionView()
        setAdviceLabel()
    }
}

// MARK: - Public Func
extension TopFiveView {
    func reloadData() {
        topFiveCollectionView.reloadData()
    }
}

// MARK: - private methods
private extension TopFiveView {
    func setVisualAppearance() {
        adviceLabel.font = TextStyle.bodySmall.font
        titleLabel.font = TextStyle.bodyBig.font
        titleLabel.textColor = UIColor.PrimaryColors.Font.header
        titleLabel.text = NSLocalizedString("topFiveWordsTitle", comment: "")
        adviceLabel.text = NSLocalizedString("topFiveWordsAdvice", comment: "")
        adviceLabel.textColor = .gray
    }

    func setTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                            constant: UIConstants.padding).isActive = true
        titleLabel.sizeToFit()
    }

    func setTopFiveCollectionView() {
        topFiveCollectionView.translatesAutoresizingMaskIntoConstraints = false
        topFiveCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                               constant: UIConstants.padding).isActive = true
        topFiveCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        topFiveCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        let height = CGFloat(UIConstants.padding
                             + UIConstants.AdviceLabel.height
                             + titleLabel.frame.height
                             + UIConstants.padding)
        topFiveCollectionView.heightAnchor.constraint(equalToConstant: frame.height - height).isActive = true
    }

    func setAdviceLabel() {
        adviceLabel.translatesAutoresizingMaskIntoConstraints = false
        adviceLabel.topAnchor.constraint(equalTo: topFiveCollectionView.bottomAnchor, constant: 5).isActive = true
        adviceLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                             constant: UIConstants.padding).isActive = true
        adviceLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                              constant: UIConstants.padding).isActive = true
        adviceLabel.heightAnchor.constraint(equalToConstant: UIConstants.AdviceLabel.height).isActive = true
    }
}

// MARK: - Constants
// swiftlint:disable nesting
private extension TopFiveView {
    struct UIConstants {
        static let padding: CGFloat = 18.0

        struct AdviceLabel {
            static let height: CGFloat = 16.0
        }
    }
}
// swiftlint:enable nesting
