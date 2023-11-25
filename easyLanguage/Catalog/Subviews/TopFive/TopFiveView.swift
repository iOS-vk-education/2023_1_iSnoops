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
            self.addSubview($0)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - life circle
extension TopFiveView {
    override func layoutSubviews() {
        super.layoutSubviews()
        setTitleLabel()
        setTopFiveCollectionView()
        setAdviceLabel()
    }
}

// MARK: - private methods
private extension TopFiveView {
    func setVisualAppearance() {
        titleLabel.textColor = .black
        titleLabel.text = TopFiveView.Consts.titleText
        adviceLabel.text = TopFiveView.Consts.adviceText
        adviceLabel.textColor = .gray
    }

    func setTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: UIConstants.TitleLabel.width).isActive = true
        titleLabel.sizeToFit()
    }

    func setTopFiveCollectionView() {
        topFiveCollectionView.translatesAutoresizingMaskIntoConstraints = false
        topFiveCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                                   constant: UIConstants.TopFiveCollectionView.top).isActive = true
        topFiveCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        topFiveCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        topFiveCollectionView.heightAnchor.constraint(equalToConstant: self.frame.width / 3).isActive = true
    }

    func setAdviceLabel() {
        adviceLabel.translatesAutoresizingMaskIntoConstraints = false
        adviceLabel.topAnchor.constraint(equalTo: topFiveCollectionView.bottomAnchor,
                                         constant: 5).isActive = true
        adviceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        adviceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        adviceLabel.heightAnchor.constraint(equalToConstant: UIConstants.AdviceLabel.height).isActive = true
    }
}

// MARK: - Constants
// swiftlint:disable nesting
private extension TopFiveView {
    struct Consts {
        static let titleText: String = "5 слов дня"
        static let adviceText: String = "Для перевода слова нажмите на карточку"
    }

    struct UIConstants {
        struct TitleLabel {
            static let width: CGFloat = 54.0
        }

        struct TopFiveCollectionView {
            static let top: CGFloat = 18.0
        }

        struct AdviceLabel {
            static let height: CGFloat = 16.0
        }
    }
}
// swiftlint:enable nesting
