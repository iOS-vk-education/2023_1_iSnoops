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
    private var ruTitle: String?
    private var engTitle: String?

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
        engTitle = nil
        ruTitle = nil
        titleLabel.text = nil
    }
}

// MARK: - open methods
extension TopFiveCollectionViewCell {
    func cellConfigure(with model: TopFiveWordsModel) {
        ruTitle = model.title["ru"]
        engTitle = model.title["en"]
        levelLabel.text = model.level
        titleLabel.text = model.title["ru"]
        let textColor: UIColor

        switch model.topFiveWordsId % 3 {
        case 0:
            backgroundColor = .Catalog.TopFive.Views.customPink
            textColor = .Catalog.TopFive.Fonts.customPink
        case 1:
            backgroundColor = .Catalog.TopFive.Views.customYellow
            textColor = .Catalog.TopFive.Fonts.customYellow
        default:
            backgroundColor = .Catalog.TopFive.Views.customBlue
            textColor = .Catalog.TopFive.Fonts.customBlue
        }
        [levelLabel, titleLabel].forEach {
            $0.textColor = textColor
        }
    }
}

// MARK: - private methods
private extension TopFiveCollectionViewCell {

    @objc
    func didTabTopFiveView() {
        let transitionOptions: UIView.AnimationOptions = .transitionFlipFromRight

        UIView.transition(with: self, duration: 0.65, options: transitionOptions, animations: {
            if self.isFlipped {
                self.titleLabel.text = self.ruTitle
            } else {
                self.titleLabel.text = self.engTitle
            }
        })
        isFlipped = !isFlipped
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
                                                 constant: 10).isActive = true
        backgroundLevelView.leftAnchor.constraint(equalTo: self.leftAnchor,
                                                  constant: 85).isActive = true
        backgroundLevelView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backgroundLevelView.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }

    func setLevelLabel() {
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.topAnchor.constraint(equalTo: backgroundLevelView.topAnchor,
                                        constant: 7).isActive = true
        levelLabel.leftAnchor.constraint(equalTo: backgroundLevelView.leftAnchor,
                                         constant: 5).isActive = true
        levelLabel.widthAnchor.constraint(equalToConstant: 20).isActive = true
        levelLabel.sizeToFit()
    }

    func setTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: backgroundLevelView.bottomAnchor,
                                        constant: 14).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor,
                                         constant: 8).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor,
                                          constant: -8).isActive = true
    }
}
