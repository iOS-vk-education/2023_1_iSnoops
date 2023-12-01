//
//  TopFiveCollectionViewCell.swift
//  easyLanguage
//
//  Created by Grigoriy on 25.10.2023.
//

import UIKit

final class TopFiveCollectionViewCell: UICollectionViewCell {

    private let backgroundLevelView = UIView()
    private let levelLabel = UILabel()
    private let titleLabel = UILabel()
    private var isFlipped = false
    private var nativeTitle: String?
    private var foreignTitle: String?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setVisualAppearance()
        [backgroundLevelView, titleLabel].forEach {
            contentView.addSubview($0)
        }
        backgroundLevelView.addSubview(levelLabel)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTabTopFiveView))
        self.addGestureRecognizer(tapGestureRecognizer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setBackgroundLevelView()
        setLevelLabel()
        setTitleLabel()
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
        nativeTitle = model.title["ru"]
        foreignTitle = model.title["en"]
        levelLabel.text = model.level
        titleLabel.text = model.title["ru"]
        setupColorsForWord(with: indexPath.item)
    }
}

// MARK: - private methods
private extension TopFiveCollectionViewCell {

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

    func setupColorsForWord(with index: Int) {
        let index = index % Constants.backgroundColors.count
        let textColor = Constants.textColors[index]
        backgroundColor = Constants.backgroundColors[index]

        [levelLabel, titleLabel].forEach {
            $0.textColor = textColor
        }
    }

    func setVisualAppearance() {
        self.layer.cornerRadius = 12
        [levelLabel, titleLabel].forEach {
            $0.textAlignment = .center
        }
        backgroundLevelView.backgroundColor = .white
        backgroundLevelView.layer.cornerRadius = 12
    }

    func setBackgroundLevelView() {
        backgroundLevelView.translatesAutoresizingMaskIntoConstraints = false
        backgroundLevelView.topAnchor.constraint(equalTo: self.topAnchor,
                                                 constant: UIConstants.BackgroundLevelView.margin).isActive = true
        backgroundLevelView.rightAnchor.constraint(equalTo: self.rightAnchor,
                                                 constant: -UIConstants.BackgroundLevelView.margin).isActive = true
        backgroundLevelView.heightAnchor.constraint(equalToConstant:
                                                 frame.width / 4).isActive = true
        backgroundLevelView.widthAnchor.constraint(equalToConstant:
                                                 frame.width / 4).isActive = true
    }

    func setLevelLabel() {
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.centerYAnchor.constraint(equalTo: backgroundLevelView.centerYAnchor).isActive = true
        levelLabel.leftAnchor.constraint(equalTo: backgroundLevelView.leftAnchor).isActive = true
        levelLabel.rightAnchor.constraint(equalTo: backgroundLevelView.rightAnchor).isActive = true
        levelLabel.sizeToFit()
    }

    func setTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        titleLabel.topAnchor.constraint(equalTo: backgroundLevelView.bottomAnchor,
//                                        constant: UIConstants.TitleLabel.top).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor,
                                         constant: UIConstants.TitleLabel.horizontally).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor,
                                          constant: -UIConstants.TitleLabel.horizontally).isActive = true
    }
}

// MARK: - Constants
private extension TopFiveCollectionViewCell {
    // swiftlint:disable nesting
    struct Constants {
        static let backgroundColors: [UIColor] = [.Catalog.Pink.topFiveBackground,
                                                  .Catalog.Yellow.topFiveBackground,
                                                  .Catalog.Blue.topFiveBackground]

        static let textColors: [UIColor] = [.Catalog.Pink.topFiveBackText,
                                            .Catalog.Yellow.topFiveBackText,
                                            .Catalog.Blue.topFiveBackText]
    }

    struct UIConstants {
        struct BackgroundLevelView {
            static let margin: CGFloat = 10.0
        }

        struct TitleLabel {
            static let horizontally: CGFloat = 8.0
        }
    }
}
// swiftlint:enable nesting
