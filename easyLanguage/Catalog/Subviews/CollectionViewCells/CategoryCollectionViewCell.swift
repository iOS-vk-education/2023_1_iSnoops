//
//  CategoryCollectionViewCell.swift
//  easyLanguage
//
//  Created by Grigoriy on 26.10.2023.
//

import UIKit

final class CategoryCollectionViewCell: UICollectionViewCell {

    private let imageManager = CatalogImageManager.shared
    private let backgroundLevelView = UIView()
    private let titleLabel = UILabel()
    private let imageView = UIImageView()
    private let progressLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()

        backgroundLevelView.addSubview(imageView)
        [backgroundLevelView, titleLabel, progressLabel].forEach {
            self.addSubview($0)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life cirle
extension CategoryCollectionViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()

        backgroundLevelView.translatesAutoresizingMaskIntoConstraints = false
        backgroundLevelView.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        backgroundLevelView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        backgroundLevelView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        backgroundLevelView.heightAnchor.constraint(equalToConstant: 40).isActive = true

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: backgroundLevelView.topAnchor, constant: 5).isActive = true
        imageView.leadingAnchor.constraint(equalTo: backgroundLevelView.leadingAnchor, constant: 5).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 83).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true

        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        progressLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        progressLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }
}

// MARK: - open methods
extension CategoryCollectionViewCell {
    func cellConfigure(with model: CategoryModel) {
        let textColor: UIColor

        if model.categoryId % 8 == 0 {
            backgroundColor = .Catalog.Category.Views.customGreen
            textColor = .Catalog.Category.Fonts.customGreen
        } else if model.categoryId % 8 == 1 {
            backgroundColor = .Catalog.Category.Views.customPurple
            textColor = .Catalog.Category.Fonts.customPurple
        } else if model.categoryId % 8 == 2 {
            backgroundColor = .Catalog.Category.Views.customLightYellow
            textColor = .Catalog.Category.Fonts.customLightYellow
        } else if model.categoryId % 8 == 3 {
            backgroundColor = .Catalog.Category.Views.customYellow
            textColor = .Catalog.Category.Fonts.customYellow
        } else if model.categoryId % 8 == 4 {
            backgroundColor = .Catalog.Category.Views.customRed
            textColor = .Catalog.Category.Fonts.customRed
        } else if model.categoryId % 8 == 5 {
            backgroundColor = .Catalog.Category.Views.customBlue
            textColor = .Catalog.Category.Fonts.customBlue
        } else if model.categoryId % 8 == 6 {
            backgroundColor = .Catalog.Category.Views.customCyan
            textColor = .Catalog.Category.Fonts.customCyan
        } else {
            backgroundColor = .Catalog.Category.Views.customPink
            textColor = .Catalog.Category.Fonts.customPink
        }

        [progressLabel, titleLabel].forEach {
            $0.textColor = textColor
        }
        progressLabel.text = String(model.studiedWordsCount) + "/" + String(model.totalWordsCount)
        titleLabel.text = model.ruTitle

        guard let url = URL(string: model.imageLink) else {
            return
        }

        imageManager.loadImage(from: url) { result in
            switch result {
            case .success(let image):
                self.imageView.image = image
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - private methods
private extension CategoryCollectionViewCell {
    func setup() {
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        self.layer.cornerRadius = 15
        backgroundLevelView.backgroundColor = .white
        backgroundLevelView.layer.cornerRadius = 15
        [progressLabel, titleLabel].forEach {
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
    }
}
