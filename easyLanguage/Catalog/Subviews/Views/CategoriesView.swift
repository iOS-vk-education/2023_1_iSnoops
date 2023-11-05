//
//  CategoriesView.swift
//  easyLanguage
//
//  Created by Grigoriy on 26.10.2023.
//

import UIKit

final class CategoriesView: UIView {

    private let model = CatalogModel()
    var categoriesModel: [CategoryModel] = [CategoryModel]()
    private let titleLabel: UILabel = UILabel()
    private let addImageView: UIImageView = UIImageView()
    private let sortImageView: UIImageView = UIImageView()
    private lazy var categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 19

        let categoriesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        categoriesCollectionView.isScrollEnabled = false
        categoriesCollectionView.showsVerticalScrollIndicator = false
        categoriesCollectionView.backgroundColor = .PrimaryColors.Background.customBackground
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.register(CategoryCollectionViewCell.self,
                                          forCellWithReuseIdentifier: "categoriesCollectionView")
        return categoriesCollectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        [categoriesCollectionView, titleLabel, addImageView, sortImageView].forEach {
            self.addSubview($0)
        }
        loadCategories()
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - life circle
extension CategoriesView {
    override func layoutSubviews() {
        super.layoutSubviews()

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        titleLabel.sizeToFit()

        addImageView.translatesAutoresizingMaskIntoConstraints = false
        addImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        addImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18).isActive = true
        addImageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        addImageView.heightAnchor.constraint(equalToConstant: 35).isActive = true

        sortImageView.translatesAutoresizingMaskIntoConstraints = false
        sortImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        sortImageView.trailingAnchor.constraint(equalTo: addImageView.leadingAnchor, constant: -18).isActive = true
        sortImageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        sortImageView.heightAnchor.constraint(equalToConstant: 35).isActive = true

        categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        categoriesCollectionView.topAnchor.constraint(equalTo: addImageView.bottomAnchor, constant: 10).isActive = true
        categoriesCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18).isActive = true
        categoriesCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18).isActive = true
        categoriesCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18).isActive = true
    }
}

// MARK: - open methods
extension CategoriesView {
    func countEvenCells() -> Int {
        if categoriesModel.count % 2 == 0 {
            return categoriesModel.count / 2
        } else {
            return categoriesModel.count / 2 + 1
        }
    }
}

// MARK: - private methods
private extension CategoriesView {
    func loadCategories() {
        model.loadCategory { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let data):
                self.categoriesModel = data
                DispatchQueue.main.async {
                    self.categoriesCollectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func setup() {
        titleLabel.text = CategoriesView.Consts.titleText
        titleLabel.textColor = .black
        addImageView.image = CategoriesView.Images.addImage
        sortImageView.image = CategoriesView.Images.sortImage
    }
}

private extension CategoriesView {
    struct Consts {
        static let titleText: String = "Категории"
    }
    struct Images {
        static let addImage = UIImage(named: "AddImage")
        static let sortImage = UIImage(named: "SortImage")
    }
}
