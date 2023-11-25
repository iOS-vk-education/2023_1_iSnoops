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
    private var isliked: Bool = false

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
        switchBackgroundColor(with: id)
        titleLabel.text = wordModel.words["ru"]
        nativeTitle = wordModel.words["ru"]
        foreignTitle = wordModel.words["en"]
        isliked = wordModel.isLearned
        updateLike(with: wordModel.isLearned)
    }
}

// MARK: - private methods
private extension CategoryDetailCollectionViewCell {
    @objc
    private func didTabLikeImageView() {
        isliked.toggle()
        updateLike(with: isliked)
    }

    func updateLike(with isLearned: Bool) {
        if isLearned == true {
            likeImageView.image = UIImage(named: "Heart.fill") ?? UIImage(systemName: "heart.fill")
        } else {
            likeImageView.image = UIImage(named: "Heart") ?? UIImage(systemName: "heart")
        }
    }

    func switchBackgroundColor(with selectedItem: Int) {
        let textColor: UIColor
        let backgroundColor: UIColor
        switch (selectedItem) % 8 {
        case 0:
            backgroundColor = .Catalog.Green.categoryBackground
            textColor = .Catalog.Green.categoryText
        case 1:
            backgroundColor = .Catalog.Purple.categoryBackground
            textColor = .Catalog.Purple.categoryText
        case 2:
            backgroundColor = .Catalog.LightYellow.categoryBackground
            textColor = .Catalog.LightYellow.categoryText
        case 3:
            backgroundColor = .Catalog.Yellow.categoryBackground
            textColor = .Catalog.Yellow.categoryText
        case 4:
            backgroundColor = .Catalog.Red.categoryBackground
            textColor = .Catalog.Red.categoryText
        case 5:
            backgroundColor = .Catalog.Blue.categoryBackground
            textColor = .Catalog.Blue.categoryText
        case 6:
            backgroundColor = .Catalog.Cyan.categoryBackground
            textColor = .Catalog.Cyan.categoryText
        default:
            backgroundColor = .Catalog.Pink.categoryBackground
            textColor = .Catalog.Pink.categoryText
        }
        titleLabel.textColor = textColor
        let modifiedBackgroundColor = UIColor.generateRandomSimilarColor(from: backgroundColor)
        self.backgroundColor = modifiedBackgroundColor
   }

    @objc
    func didTabTopFiveView() {
        let transitionOptions: UIView.AnimationOptions = .transitionFlipFromRight

        UIView.transition(with: self, duration: 0.65, options: transitionOptions, animations: {
            if self.isFlipped {
                self.titleLabel.text = self.nativeTitle
            } else {
                self.titleLabel.text = self.foreignTitle
            }
        })
        isFlipped = !isFlipped
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
