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
        backgroundLevelView.addSubview(levelLabel)
        [backgroundLevelView, titleLabel].forEach {
            addSubview($0)
        }
        setBackgroundLevelView()
        setLevelLabel()
        setTitleLabel()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTabTopFiveView))
        self.addGestureRecognizer(tapGestureRecognizer)
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
        let textColor: UIColor

        switch index % 3 {
        case 0:
            backgroundColor = .Catalog.Pink.topFiveBackground
            textColor = .Catalog.Pink.topFiveBackText
        case 1:
            backgroundColor = .Catalog.Yellow.topFiveBackground
            textColor =  .Catalog.Yellow.topFiveBackText
        default:
            backgroundColor = .Catalog.Blue.topFiveBackground
            textColor =  .Catalog.Blue.topFiveBackText
        }
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
        print("frame", frame)
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
        levelLabel.topAnchor.constraint(equalTo: backgroundLevelView.topAnchor,
                                        constant: UIConstants.LevelLabel.top).isActive = true
        levelLabel.leftAnchor.constraint(equalTo: backgroundLevelView.leftAnchor,
                                         constant: UIConstants.LevelLabel.left).isActive = true
        levelLabel.widthAnchor.constraint(equalToConstant: frame.width / 6.25).isActive = true
        levelLabel.sizeToFit()
    }

    func setTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: backgroundLevelView.bottomAnchor,
                                        constant: UIConstants.TitleLabel.top).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor,
                                         constant: UIConstants.TitleLabel.horizontally).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor,
                                          constant: -UIConstants.TitleLabel.horizontally).isActive = true
    }
}

// MARK: - Constants
private extension TopFiveCollectionViewCell {
    // swiftlint:disable nesting
    struct UIConstants {
        struct BackgroundLevelView {
            static let margin: CGFloat = 10.0
        }

        struct LevelLabel {
            static let top: CGFloat = 7.0
            static let left: CGFloat = 5.0
        }

        struct TitleLabel {
            static let top: CGFloat = 14.0
            static let horizontally: CGFloat = 8.0
        }
    }
}
// swiftlint:enable nesting
