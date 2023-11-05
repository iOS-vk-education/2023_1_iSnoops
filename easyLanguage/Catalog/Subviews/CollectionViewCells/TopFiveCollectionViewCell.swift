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
        setup()

        backgroundLevelView.addSubview(levelLabel)
        [backgroundLevelView, titleLabel].forEach {
            addSubview($0)
        }

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTabTopFiveView))
        self.addGestureRecognizer(tapGestureRecognizer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life cirle
extension TopFiveCollectionViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()

        backgroundLevelView.translatesAutoresizingMaskIntoConstraints = false
        backgroundLevelView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        backgroundLevelView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 85).isActive = true
        backgroundLevelView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backgroundLevelView.widthAnchor.constraint(equalToConstant: 30).isActive = true

        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.topAnchor.constraint(equalTo: backgroundLevelView.topAnchor, constant: 7).isActive = true
        levelLabel.leftAnchor.constraint(equalTo: backgroundLevelView.leftAnchor, constant: 5).isActive = true
        levelLabel.widthAnchor.constraint(equalToConstant: 20).isActive = true
        levelLabel.sizeToFit()

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: backgroundLevelView.bottomAnchor, constant: 14).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
    }
}

// MARK: - open methods
extension TopFiveCollectionViewCell {
    func cellConfigure(with model: TopFiveWordsModel) {
        let textColor: UIColor

        if model.topFiveWordsId % 3 == 0 {
            backgroundColor = .Catalog.TopFive.Views.customPink
            textColor = .Catalog.TopFive.Fonts.customPink
        } else if model.topFiveWordsId % 3 == 1 {
            backgroundColor = .Catalog.TopFive.Views.customYellow
            textColor = .Catalog.TopFive.Fonts.customYellow
        } else {
            backgroundColor = .Catalog.TopFive.Views.customBlue
            textColor = .Catalog.TopFive.Fonts.customBlue
        }

        [levelLabel, titleLabel].forEach {
            $0.textColor = textColor
        }

        ruTitle = model.ruTitle
        engTitle = model.engTitle
        levelLabel.text = model.level
        titleLabel.text = model.ruTitle
    }
}

// MARK: - private methods
private extension TopFiveCollectionViewCell {
    func setup() {
        self.layer.cornerRadius = 12
        backgroundLevelView.backgroundColor = .white
        backgroundLevelView.layer.cornerRadius = 12
        [levelLabel, titleLabel].forEach {
            $0.textAlignment = .center
        }
    }

    @objc
    func didTabTopFiveView() {
        let transitionOptions: UIView.AnimationOptions = .transitionFlipFromRight

        UIView.transition(with: self, duration: 0.65, options: transitionOptions, animations: {
            if self.isFlipped {
                self.titleLabel.text = self.ruTitle
            } else {
                self.titleLabel.text = self.engTitle
            }
        }, completion: nil)
        isFlipped = !isFlipped
    }
}
