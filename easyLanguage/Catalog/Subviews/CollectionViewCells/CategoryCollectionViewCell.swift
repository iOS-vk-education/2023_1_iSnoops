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
//    func cellConfigure(with model: CategoryUIModel) {
//        setupColorsForCategory(with: model.categoryId)
//        setupProgressAndTitleLabels(with: model)
//        imageView.image = model.image
//    }
    func cellConfigure(with model: CategoryUIModel, at indexPath: IndexPath) {
        setupColorsForCategory(with: indexPath.item)
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

    func setupColorsForCategory(with index: Int) {
        let backgroundColor: UIColor
        let textColor: UIColor

        switch index % 8 {
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
                                                 constant: UIConstants.BackgroundLevelView.top).isActive = true
        backgroundLevelView.trailingAnchor.constraint(equalTo: trailingAnchor, constant:
                                                    -UIConstants.BackgroundLevelView.trailing).isActive = true
        backgroundLevelView.widthAnchor.constraint(equalToConstant:
                                                    UIConstants.BackgroundLevelView.width).isActive = true
        backgroundLevelView.heightAnchor.constraint(equalToConstant:
                                                    UIConstants.BackgroundLevelView.height).isActive = true
    }

    func setImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: backgroundLevelView.topAnchor,
                                       constant: UIConstants.ImageView.top).isActive = true
        imageView.leadingAnchor.constraint(equalTo: backgroundLevelView.leadingAnchor,
                                           constant: UIConstants.ImageView.leading).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: UIConstants.ImageView.width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: UIConstants.ImageView.height).isActive = true
    }

    func setTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: topAnchor,
                                        constant: UIConstants.TitleLabel.top).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                            constant: UIConstants.TitleLabel.leading).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                             constant: -UIConstants.TitleLabel.trailing).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: UIConstants.TitleLabel.height).isActive = true
    }

    func setProgressLabel() {
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.topAnchor.constraint(equalTo: topAnchor,
                                           constant: UIConstants.ProgressLabel.top).isActive = true
        progressLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: UIConstants.ProgressLabel.leading).isActive = true
        progressLabel.widthAnchor.constraint(equalToConstant: UIConstants.ProgressLabel.width).isActive = true
    }
}

// MARK: - Constants
private extension CategoryCollectionViewCell {
    // swiftlint:disable nesting
    struct UIConstants {
        struct BackgroundLevelView {
            static let top: CGFloat = 15.0
            static let trailing: CGFloat = 15.0
            static let height: CGFloat = 40.0
            static let width: CGFloat = 40.0
        }

        struct ImageView {
            static let top: CGFloat = 5.0
            static let leading: CGFloat = 5.0
            static let width: CGFloat = 30.0
            static let height: CGFloat = 30.0
        }

        struct TitleLabel {
            static let top: CGFloat = 83.0
            static let leading: CGFloat = 15.0
            static let trailing: CGFloat = 15.0
            static let height: CGFloat = 50.0
        }

        struct ProgressLabel {
            static let top: CGFloat = 20.0
            static let leading: CGFloat = 15.0
            static let width: CGFloat = 60.0
        }
    }
}
// swiftlint:enable nesting
