//
//  CategoryDetailCollectionViewCell.swift
//  easyLanguage
//
//  Created by Grigoriy on 10.12.2023.
//

import UIKit

protocol CategoryDetailCellOutput {
    func didTapMarkIcon()
    func didTapCell()
}

final class CategoryDetailCollectionViewCell: UICollectionViewCell {
    private let title = UILabel()
    private let markIcon = UIImageView()
    private var nativeTitle: String?
    private var foreignTitle: String?
    private var isFlipped = false
    private var cellBackgroundColor: UIColor?
    private var wordUIModel: WordUIModel?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setAppearance()
        [title, markIcon].forEach {
            contentView.addSubview($0)
        }
        addConstraints()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCell))
        self.addGestureRecognizer(tapGesture)
        layer.cornerRadius = 15
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - life cycle
extension CategoryDetailCollectionViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        isFlipped = false
        foreignTitle = nil
        nativeTitle = nil
        title.text = nil
    }
}

// MARK: - internal methods
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
        title.textColor = colors.textColor
    }

    func updateTitleLabel() {
        if isFlipped {
            title.text = foreignTitle
        } else {
            title.text = nativeTitle
        }
    }

    func updateLike(with isLearned: Bool) {
        markIcon.image = UIImage(named: isLearned ? "Star.fill" : "Star")
    }
}

// MARK: - set appearance elements
private extension CategoryDetailCollectionViewCell {
    func setAppearance() {
        titleAppearance()
        markIconAppearence()
    }

    func titleAppearance() {
        title.numberOfLines = 0
        title.textAlignment = .center
    }

    func markIconAppearence() {
        markIcon.clipsToBounds = true
        markIcon.contentMode = .scaleAspectFit

        markIcon.isUserInteractionEnabled = true
        let tapGesture =  UITapGestureRecognizer(target: self, action: #selector(didTapMarkIcon))
        markIcon.addGestureRecognizer(tapGesture)
    }
}

// MARK: - set constraints
private extension CategoryDetailCollectionViewCell {
    func addConstraints() {
        setTitle()
        setMarkIcon()
    }

    func setTitle() {
        title.translatesAutoresizingMaskIntoConstraints = false
        title.topAnchor.constraint(equalTo: topAnchor,
                                        constant: UIConstants.TitleLabel.padding).isActive = true
        title.leadingAnchor.constraint(equalTo: leadingAnchor,
                                        constant: UIConstants.TitleLabel.padding).isActive = true
        title.trailingAnchor.constraint(equalTo: trailingAnchor,
                                        constant: -UIConstants.TitleLabel.padding).isActive = true
        title.bottomAnchor.constraint(equalTo: bottomAnchor,
                                        constant: -UIConstants.TitleLabel.padding).isActive = true
    }

    func setMarkIcon() {
        markIcon.translatesAutoresizingMaskIntoConstraints = false
        markIcon.topAnchor.constraint(equalTo: topAnchor,
                                        constant: UIConstants.LikeImageView.topLeft).isActive = true
        markIcon.leadingAnchor.constraint(equalTo: leadingAnchor,
                                        constant: UIConstants.LikeImageView.topLeft).isActive = true
        markIcon.widthAnchor.constraint(equalToConstant: UIConstants.LikeImageView.size).isActive = true
        markIcon.heightAnchor.constraint(equalToConstant: UIConstants.LikeImageView.size).isActive = true
    }
}

// MARK: - Constants
// swiftlint:disable nesting
private extension CategoryDetailCollectionViewCell {
    struct Constants {
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

// MARK: - CategoryDetailCellOutput
extension CategoryDetailCollectionViewCell: CategoryDetailCellOutput {
    @objc
    func didTapMarkIcon() {
        guard let wordUIModel = wordUIModel else {
            return
        }
        // обновление лайка на беке
        updateLike(with: !wordUIModel.isLearned)
    }

    @objc
    func didTapCell() {
        let transitionOptions: UIView.AnimationOptions = .transitionFlipFromRight
        isFlipped = !isFlipped
        UIView.transition(with: self, duration: 0.65, options: transitionOptions, animations: { [weak self] in
            self?.updateTitleLabel()
        })
    }
}
