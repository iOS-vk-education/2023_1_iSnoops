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
    private let addNewCategoryLogo: UIImageView = UIImageView()
    private let sortCategoriesLogo: UIImageView = UIImageView()
    private lazy var categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()

        let categoriesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        categoriesCollectionView.isScrollEnabled = false
        categoriesCollectionView.showsVerticalScrollIndicator = false
        categoriesCollectionView.backgroundColor = .PrimaryColors.Background.customBackground
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.register(CategoryCollectionViewCell.self,
                                          forCellWithReuseIdentifier: "categoriesCollectionView")
        if let flowLayout = categoriesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumLineSpacing = UIScreen.main.bounds.width / 20.5
        }
        return categoriesCollectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setVisualAppearance()
        [categoriesCollectionView, titleLabel, addNewCategoryLogo, sortCategoriesLogo].forEach {
            self.addSubview($0)
        }
        loadCategories()
        setTitleLabel()
        setAddImageView()
        setSortImageView()
        setCategoriesCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

    func setVisualAppearance() {
        titleLabel.text = CategoriesView.Consts.titleText
        titleLabel.textColor = .black
        addNewCategoryLogo.image = CategoriesView.Images.addImage
        sortCategoriesLogo.image = CategoriesView.Images.sortImage
    }

    func setTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: topAnchor,
                                        constant: 6).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        titleLabel.sizeToFit()
    }

    func setAddImageView() {
        addNewCategoryLogo.translatesAutoresizingMaskIntoConstraints = false
        addNewCategoryLogo.topAnchor.constraint(equalTo: topAnchor).isActive = true
        addNewCategoryLogo.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                     constant: -18).isActive = true
        addNewCategoryLogo.widthAnchor.constraint(equalToConstant: 35).isActive = true
        addNewCategoryLogo.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }

    func setSortImageView() {
        sortCategoriesLogo.translatesAutoresizingMaskIntoConstraints = false
        sortCategoriesLogo.topAnchor.constraint(equalTo: topAnchor).isActive = true
        sortCategoriesLogo.trailingAnchor.constraint(equalTo: addNewCategoryLogo.leadingAnchor,
                                                     constant: -18).isActive = true
        sortCategoriesLogo.widthAnchor.constraint(equalToConstant: 35).isActive = true
        sortCategoriesLogo.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }

    func setCategoriesCollectionView() {
        categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        categoriesCollectionView.topAnchor.constraint(equalTo: addNewCategoryLogo.bottomAnchor,
                                                      constant: 10).isActive = true
        categoriesCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                          constant: 18).isActive = true
        categoriesCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                           constant: -18).isActive = true
        categoriesCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                         constant: -18).isActive = true
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
