//
//  CategoryCollectionViewCell.swift
//  easyLanguage
//
//  Created by Grigoriy on 26.10.2023.
//

import UIKit

final class CategoryCollectionViewCell: UICollectionViewCell {

    private let backgroundLevelView = UIView()
    private let titleLabel = UILabel()
    private let imageView = UIImageView()
    private let progressLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setVisualAppearance()

        backgroundLevelView.addSubview(imageView)
        [backgroundLevelView, titleLabel, progressLabel].forEach {
            self.addSubview($0)
        }
        setBackgroundLevelView()
        setImageView()
        setTitleLabel()
        setProgressLabel()
        setupLabels()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - open methods
extension CategoryCollectionViewCell {
    func cellConfigure(with model: CategoryUIModel) {
        setupColorsForCategory(with: model.categoryId)
        setupProgressAndTitleLabels(with: model)
        imageView.image = model.image
    }
}

// MARK: - private methods
private extension CategoryCollectionViewCell {
    func setVisualAppearance() {
        self.layer.cornerRadius = 15
        [progressLabel, titleLabel].forEach {
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        backgroundLevelView.backgroundColor = .white
        backgroundLevelView.layer.cornerRadius = 15
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
    }

    func setupColorsForCategory(with categoryId: Int) {
        let backgroundColor: UIColor
        let textColor: UIColor

        switch categoryId % 8 {
        case 0:
            backgroundColor = .Catalog.Category.Views.customGreen
            textColor = .Catalog.Category.Fonts.customGreen
        case 1:
            backgroundColor = .Catalog.Category.Views.customPurple
            textColor = .Catalog.Category.Fonts.customPurple
        case 2:
            backgroundColor = .Catalog.Category.Views.customLightYellow
            textColor = .Catalog.Category.Fonts.customLightYellow
        case 3:
            backgroundColor = .Catalog.Category.Views.customYellow
            textColor = .Catalog.Category.Fonts.customYellow
        case 4:
            backgroundColor = .Catalog.Category.Views.customRed
            textColor = .Catalog.Category.Fonts.customRed
        case 5:
            backgroundColor = .Catalog.Category.Views.customBlue
            textColor = .Catalog.Category.Fonts.customBlue
        case 6:
            backgroundColor = .Catalog.Category.Views.customCyan
            textColor = .Catalog.Category.Fonts.customCyan
        default:
            backgroundColor = .Catalog.Category.Views.customPink
            textColor = .Catalog.Category.Fonts.customPink
        }

        self.backgroundColor = backgroundColor
        [progressLabel, titleLabel].forEach { $0.textColor = textColor }
    }

    func setupLabels() {
        [progressLabel, titleLabel].forEach {
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
    }

    func setupProgressAndTitleLabels(with model: CategoryUIModel) {
        progressLabel.text = "\(model.studiedWordsCount)/\(model.totalWordsCount)"
        titleLabel.text = model.title["ru"]
    }

    func setBackgroundLevelView() {
        backgroundLevelView.translatesAutoresizingMaskIntoConstraints = false
        backgroundLevelView.topAnchor.constraint(equalTo: topAnchor,
                                                 constant: 15).isActive = true
        backgroundLevelView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                      constant: -15).isActive = true
        backgroundLevelView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        backgroundLevelView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }

    func setImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: backgroundLevelView.topAnchor,
                                       constant: 5).isActive = true
        imageView.leadingAnchor.constraint(equalTo: backgroundLevelView.leadingAnchor,
                                           constant: 5).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

    func setTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: topAnchor,
                                        constant: 83).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                            constant: 15).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                             constant: -15).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    func setProgressLabel() {
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.topAnchor.constraint(equalTo: topAnchor,
                                           constant: 20).isActive = true
        progressLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: 15).isActive = true
        progressLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }
}
