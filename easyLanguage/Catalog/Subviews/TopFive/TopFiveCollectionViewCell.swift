//
//  TopFiveCollectionViewCell.swift
//  easyLanguage
//
//  Created by Grigoriy on 25.10.2023.
//

import UIKit

final class TopFiveCollectionViewCell: UICollectionViewCell {

    private let titleLabel = UILabel()
    private var isFlipped = false
    private var nativeTitle: String?
    private var foreignTitle: String?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setAppearance()
        addConstraints()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTabTopFiveView))
        addGestureRecognizer(tapGestureRecognizer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life cirle
extension TopFiveCollectionViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        isFlipped = false
        foreignTitle = nil
        nativeTitle = nil
        titleLabel.text = nil
    }
}

// MARK: - open methods
extension TopFiveCollectionViewCell {
    func cellConfigure(with model: TopFiveWordsModel, at indexPath: IndexPath) {
        nativeTitle = model.translate["ru"]
        foreignTitle = model.translate["en"]
        titleLabel.text = model.translate["ru"]
        setupColorsForWord(with: indexPath.item)
    }
}

// MARK: - private methods
private extension TopFiveCollectionViewCell {
    @objc
    func didTabTopFiveView() {
        let transitionOptions: UIView.AnimationOptions = .transitionFlipFromRight

        UIView.transition(with: self, duration: 0.65, options: transitionOptions, animations: { [weak self] in
            if let isFlipped = self?.isFlipped {
                if isFlipped {
                    self?.titleLabel.text = self?.nativeTitle
                } else {
                    self?.titleLabel.text = self?.foreignTitle
                }
            }
        })
        isFlipped = !isFlipped
    }

    func setupColorsForWord(with index: Int) {
        let index = index % Constants.colors.count
        let colors = Constants.colors[index]

        backgroundColor = colors.backgroundColor
        titleLabel.textColor = colors.textColor
    }

    func setAppearance() {
        layer.cornerRadius = 12
        titleLabel.textAlignment = .center
        titleLabel.font = TextStyle.bodyMedium.font
        titleLabel.numberOfLines = 0
    }

    func addConstraints() {
        contentView.addSubview(titleLabel)
        setTitleLabel()
    }

    func setTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor,
                                         constant: UIConstants.TitleLabel.horizontally).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor,
                                          constant: -UIConstants.TitleLabel.horizontally).isActive = true
    }
}

// MARK: - Constants
private extension TopFiveCollectionViewCell {
    // swiftlint:disable nesting
    struct Constants {
        static let colors: [(backgroundColor: UIColor, textColor: UIColor)] = [
            (.Catalog.Pink.topFiveBackground, .Catalog.Pink.topFiveBackText),
            (.Catalog.Yellow.topFiveBackground, .Catalog.Yellow.topFiveBackText),
            (.Catalog.Blue.topFiveBackground, .Catalog.Blue.topFiveBackText)
        ]
    }

    struct UIConstants {
        struct TitleLabel {
            static let horizontally: CGFloat = 3.0
        }
    }
}
// swiftlint:enable nesting
