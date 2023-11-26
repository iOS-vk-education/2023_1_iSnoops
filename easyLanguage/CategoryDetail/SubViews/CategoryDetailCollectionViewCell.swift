//
//  CategoryDetailCollectionViewCell.swift
//  easyLanguage
//
//  Created by Grigoriy on 22.11.2023.
//

import UIKit

final class CategoryDetailCollectionViewCell: UICollectionViewCell {

    private let titleLabel = UILabel()
    private let likeImageView = UIImageView()
    private var nativeTitle: String?
    private var foreignTitle: String?
    private var isFlipped = false
    private var wordModel: WordModel?
    weak var delegate: ChangeLikeStatеDelegate?
    private var cellBackgroundColor: UIColor?

    override init(frame: CGRect) {
        super.init(frame: frame)

        [titleLabel, likeImageView].forEach {
            addSubview($0)
        }
        setVisualAppearance()
        setTitleLabel()
        setLikeImageView()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTabTopFiveView))
        self.addGestureRecognizer(tapGestureRecognizer)

        likeImageView.isUserInteractionEnabled = true
        let likeTapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(didTabLikeImageView))
        likeImageView.addGestureRecognizer(likeTapGestureRecognizer)
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
    func cellConfigure(with id: Int, wordModel: WordModel) {
        self.wordModel = wordModel
        if cellBackgroundColor == nil {
            switchBackgroundColor(with: id)
        }
        nativeTitle = wordModel.words["ru"]
        foreignTitle = wordModel.words["en"]
        updateLike(with: wordModel.isLearned)
        updateTitleLabel()
    }

    func setChangeLikeStatеDelegate(with delegate: ChangeLikeStatеDelegate) {
        self.delegate = delegate
    }
}

// MARK: - private methods
private extension CategoryDetailCollectionViewCell {
    func updateTitleLabel() {
        if isFlipped {
            titleLabel.text = nativeTitle
        } else {
            titleLabel.text = foreignTitle
        }
    }

    @objc
    func didTabLikeImageView() {
        guard let wordModel = wordModel else {
            return
        }
        delegate?.changeIsLiked(with: wordModel.wordId ?? 0)
        updateLike(with: !wordModel.isLearned)
    }

    func updateLike(with isLearned: Bool) {
        likeImageView.image = UIImage(named: isLearned ? Constants.heartFilled : Constants.heartEmpty)
    }

    func switchBackgroundColor(with selectedItem: Int) {
        let index = selectedItem % Constants.backgroundColors.count
        let textColor = Constants.textColors[index]
        let backgroundColor = Constants.backgroundColors[index]

        titleLabel.textColor = textColor
        let modifiedBackgroundColor = UIColor.generateRandomSimilarColor(from: backgroundColor)
        self.backgroundColor = modifiedBackgroundColor
        cellBackgroundColor = modifiedBackgroundColor
   }

    @objc
    func didTabTopFiveView() {
        let transitionOptions: UIView.AnimationOptions = .transitionFlipFromRight
        isFlipped = !isFlipped
        UIView.transition(with: self, duration: 0.65, options: transitionOptions, animations: { [weak self] in
            self?.updateTitleLabel()
        })
    }

    func setVisualAppearance() {
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center

        self.layer.cornerRadius = 15
        backgroundColor = .systemRed.withAlphaComponent(0.5)
        likeImageView.clipsToBounds = true
        likeImageView.contentMode = .scaleAspectFit
    }

    func setTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor,
                                        constant: UIConstants.TitleLabel.padding).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                        constant: UIConstants.TitleLabel.padding).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                        constant: -UIConstants.TitleLabel.padding).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                        constant: UIConstants.TitleLabel.padding).isActive = true
    }

    func setLikeImageView() {
        likeImageView.translatesAutoresizingMaskIntoConstraints = false
        likeImageView.topAnchor.constraint(equalTo: self.topAnchor,
                                        constant: UIConstants.LikeImageView.topLeft).isActive = true
        likeImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                        constant: UIConstants.LikeImageView.topLeft).isActive = true
        likeImageView.widthAnchor.constraint(equalToConstant: UIConstants.LikeImageView.width).isActive = true
        likeImageView.heightAnchor.constraint(equalToConstant: UIConstants.LikeImageView.height).isActive = true
    }
}

// MARK: - Constants
// swiftlint:disable nesting
private extension CategoryDetailCollectionViewCell {
    struct Constants {
        static let heartEmpty = "Heart"
        static let heartFilled = "Heart.fill"
        static let backgroundColors: [UIColor] = [.Catalog.Green.categoryBackground,
                                         .Catalog.Purple.categoryBackground,
                                         .Catalog.LightYellow.categoryBackground,
                                         .Catalog.Yellow.categoryBackground,
                                         .Catalog.Red.categoryBackground,
                                         .Catalog.Blue.categoryBackground,
                                         .Catalog.Cyan.categoryBackground,
                                         .Catalog.Pink.categoryBackground]

        static let textColors: [UIColor] = [.Catalog.Green.categoryText,
                                             .Catalog.Purple.categoryText,
                                             .Catalog.LightYellow.categoryText,
                                             .Catalog.Yellow.categoryText,
                                             .Catalog.Red.categoryText,
                                             .Catalog.Blue.categoryText,
                                             .Catalog.Cyan.categoryText,
                                             .Catalog.Pink.categoryText]
    }

    struct UIConstants {
        struct TitleLabel {
            static let padding: CGFloat = 10.0
        }

        struct LikeImageView {
            static let topLeft: CGFloat = 10.0
            static let width: CGFloat = 35.0
            static let height: CGFloat = 35.0
        }
    }
}
// swiftlint:enable nesting
