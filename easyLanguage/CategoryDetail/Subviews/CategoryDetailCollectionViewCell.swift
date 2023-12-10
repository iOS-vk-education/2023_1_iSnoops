//
//  CategoryDetailCollectionViewCell.swift
//  easyLanguage
//
//  Created by Grigoriy on 10.12.2023.
//

import UIKit

protocol CategoryDetailCollectionViewCellTaps {
    func didTabTopFiveView()
    func didTabLikeImageView()
}

final class CategoryDetailCollectionViewCell: UICollectionViewCell {

    private let titleLabel = UILabel()
    private let likeImageView = UIImageView()
    private var nativeTitle: String?
    private var foreignTitle: String?
    private var isFlipped = false
    private var cellBackgroundColor: UIColor?
    private var wordUIModel: WordUIModel?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setVisualAppearance()
        [titleLabel, likeImageView].forEach {
            contentView.addSubview($0)
        }
        setTitleLabel()
        setLikeImageView()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTabTopFiveView))
        self.addGestureRecognizer(tapGestureRecognizer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life circle
extension CategoryDetailCollectionViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        isFlipped = false
        foreignTitle = nil
        nativeTitle = nil
        titleLabel.text = nil
    }
}

// MARK: - methods
extension CategoryDetailCollectionViewCell {
    func cellConfigure(with index: Int, wordUIModel: WordUIModel) {
        self.wordUIModel = wordUIModel
        nativeTitle = wordUIModel.translations["ru"]
        foreignTitle = wordUIModel.translations["en"]
        if cellBackgroundColor == nil {
            setColors(with: index)
        }
        updateLike(with: wordUIModel.isLearned)
        updateTitleLabel()
    }
}

// MARK: - private methods
private extension CategoryDetailCollectionViewCell {
    func setColors(with index: Int) {
        let index = index % Constants.colors.count
        let colors = Constants.colors[index]
        let modifiedBackgroundColor = UIColor.generateRandomSimilarColor(from: colors.backgroundColor)

        backgroundColor = modifiedBackgroundColor
        cellBackgroundColor = modifiedBackgroundColor
        titleLabel.textColor = colors.textColor
    }

    func setVisualAppearance() {
        configureTopFiveView()
        configureTitleLabel()
        configureLikeImageView()
    }

    func configureTopFiveView() {
        layer.cornerRadius = Constants.cornerRadius
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTabTopFiveView))
        self.addGestureRecognizer(tapGestureRecognizer)
    }

    func configureTitleLabel() {
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
    }

    func configureLikeImageView() {
        likeImageView.clipsToBounds = true
        likeImageView.contentMode = .scaleAspectFit

        likeImageView.isUserInteractionEnabled = true
        let likeTapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(didTabLikeImageView))
        likeImageView.addGestureRecognizer(likeTapGestureRecognizer)
    }

    func setTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: topAnchor,
                                        constant: UIConstants.TitleLabel.padding).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                        constant: UIConstants.TitleLabel.padding).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                        constant: -UIConstants.TitleLabel.padding).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor,
                                        constant: -UIConstants.TitleLabel.padding).isActive = true
    }

    func setLikeImageView() {
        likeImageView.translatesAutoresizingMaskIntoConstraints = false
        likeImageView.topAnchor.constraint(equalTo: topAnchor,
                                        constant: UIConstants.LikeImageView.topLeft).isActive = true
        likeImageView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                        constant: UIConstants.LikeImageView.topLeft).isActive = true
        likeImageView.widthAnchor.constraint(equalToConstant: UIConstants.LikeImageView.size).isActive = true
        likeImageView.heightAnchor.constraint(equalToConstant: UIConstants.LikeImageView.size).isActive = true
    }
}

extension CategoryDetailCollectionViewCell: CategoryDetailCollectionViewCellTaps {
    @objc
    func didTabLikeImageView() {
        guard let wordUIModel = wordUIModel else {
            return
        }
        // обдновление лайка на беке
        updateLike(with: !wordUIModel.isLearned)
    }

    @objc
    func didTabTopFiveView() {
        let transitionOptions: UIView.AnimationOptions = .transitionFlipFromRight
        isFlipped = !isFlipped
        UIView.transition(with: self, duration: 0.65, options: transitionOptions, animations: { [weak self] in
            self?.updateTitleLabel()
        })
    }

    private func updateTitleLabel() {
        if isFlipped {
            titleLabel.text = foreignTitle
        } else {
            titleLabel.text = nativeTitle
        }
    }

    private func updateLike(with isLearned: Bool) {
        likeImageView.image = UIImage(named: isLearned ? ImageConstants.filledStar : ImageConstants.emptyStar)
    }
}

// MARK: - Constants
// swiftlint:disable nesting
private extension CategoryDetailCollectionViewCell {
    struct ImageConstants {
        static let emptyStar = "Star"
        static let filledStar = "Star.fill"
    }

    struct Constants {
        static let cornerRadius: CGFloat = 15

        static let colors: [(backgroundColor: UIColor, textColor: UIColor)] = [
            (.Catalog.Green.categoryBackground, .Catalog.Green.categoryText),
            (.Catalog.Purple.categoryBackground, .Catalog.Purple.categoryText),
            (.Catalog.LightYellow.categoryBackground, .Catalog.LightYellow.categoryText),
            (.Catalog.Yellow.categoryBackground, .Catalog.Yellow.categoryText),
            (.Catalog.Red.categoryBackground, .Catalog.Red.categoryText),
            (.Catalog.Blue.categoryBackground, .Catalog.Blue.categoryText),
            (.Catalog.Cyan.categoryBackground, .Catalog.Cyan.categoryText),
            (.Catalog.Pink.categoryBackground, .Catalog.Pink.categoryText)
        ]
    }

    struct UIConstants {
        struct TitleLabel {
            static let padding: CGFloat = 10.0
        }

        struct LikeImageView {
            static let topLeft: CGFloat = 10.0
            static let size: CGFloat = 35.0
        }
    }
}
// swiftlint:enable nesting
