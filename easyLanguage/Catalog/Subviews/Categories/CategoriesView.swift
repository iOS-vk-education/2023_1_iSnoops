//
//  CategoriesView.swift
//  easyLanguage
//
//  Created by Grigoriy on 26.10.2023.
//

import UIKit
protocol CategoriesViewTaps {
    func didTapSortCategoriesLogo()
    func didTapAddNewCategoryLogo()
}

final class CategoriesView: UIView {
    private let titleLabel: UILabel = UILabel()
    private let addNewCategoryLogo: UIImageView = UIImageView()
    private let sortCategoriesLogo: UIImageView = UIImageView()
    weak var inputCategories: InputCategoriesDelegate?
    private let categoriesCollectionView = CategoriesCollectionView()
    weak var delegate: CategoriesViewDelegate?

    init(inputCategories: InputCategoriesDelegate, delegate: CategoriesViewDelegate?) {
        super.init(frame: .zero)

        self.inputCategories = inputCategories
        self.delegate = delegate
        categoriesCollectionView.setupInputCategoriesDelegate(with: inputCategories)

        setVisualAppearance()
        [categoriesCollectionView, titleLabel, addNewCategoryLogo, sortCategoriesLogo].forEach {
            addSubview($0)
        }

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        setTitleLabel()
        setAddImageView()
        setSortImageView()
        setCategoriesCollectionView()
    }
}

extension CategoriesView {
    func updateCollectionView(with categoryModel: [CategoryModel]) {
        let indexPathsToUpdate = (0..<categoryModel.count).map { IndexPath(item: $0, section: 0) }
        // performBatchUpdates - для атомарного обновления (одна неделимая единица)
        categoriesCollectionView.performBatchUpdates {
            for newIndex in indexPathsToUpdate {
                // Обновление данных в ячейках
                if let cell = categoriesCollectionView.cellForItem(at: newIndex) as? CategoryCollectionViewCell {
                    categoriesCollectionView.inputCategories?.item(at: newIndex.item) { categoryUIModel in
                        cell.cellConfigure(with: categoryUIModel, at: newIndex)
                    }
                }
            }
        }

        delegate?.endRefreshing()
    }
}

// MARK: - private methods
private extension CategoriesView {
    func setVisualAppearance() {
        configureTitleLabel()
        configureAddNewCategoryLogo()
        configureSortCategoriesLogo()
    }

    func configureTitleLabel() {
        titleLabel.text = CategoriesView.Consts.titleText
        titleLabel.textColor = .black
    }

    func configureAddNewCategoryLogo() {
        addNewCategoryLogo.image = CategoriesView.Icons.addImage
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapAddNewCategoryLogo))
        sortCategoriesLogo.isUserInteractionEnabled = true
        sortCategoriesLogo.addGestureRecognizer(tapGesture)
    }

    func configureSortCategoriesLogo() {
        sortCategoriesLogo.image = CategoriesView.Icons.sortImage

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSortCategoriesLogo))
        sortCategoriesLogo.isUserInteractionEnabled = true
        sortCategoriesLogo.addGestureRecognizer(tapGesture)
    }

    func setTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                            constant: UIConstants.TitleLabel.leading).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: UIConstants.TitleLabel.width).isActive = true
        titleLabel.sizeToFit()
    }

    func setAddImageView() {
        addNewCategoryLogo.translatesAutoresizingMaskIntoConstraints = false
        addNewCategoryLogo.topAnchor.constraint(equalTo: topAnchor).isActive = true
        addNewCategoryLogo.trailingAnchor.constraint(equalTo: trailingAnchor, constant:
                                                    -UIConstants.AddNewCategoryLogo.trailing).isActive = true
        addNewCategoryLogo.widthAnchor.constraint(equalToConstant:
                                                    UIConstants.AddNewCategoryLogo.size).isActive = true
        addNewCategoryLogo.heightAnchor.constraint(equalToConstant:
                                                    UIConstants.AddNewCategoryLogo.size).isActive = true
    }

    func setSortImageView() {
        sortCategoriesLogo.translatesAutoresizingMaskIntoConstraints = false
        sortCategoriesLogo.topAnchor.constraint(equalTo: topAnchor).isActive = true
        sortCategoriesLogo.trailingAnchor.constraint(equalTo: addNewCategoryLogo.leadingAnchor, constant:
                                                    -UIConstants.SortCategoriesLogo.trailing).isActive = true
        sortCategoriesLogo.widthAnchor.constraint(equalToConstant:
                                                    UIConstants.SortCategoriesLogo.size).isActive = true
        sortCategoriesLogo.heightAnchor.constraint(equalToConstant:
                                                    UIConstants.SortCategoriesLogo.size).isActive = true
    }

    func setCategoriesCollectionView() {
        categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        categoriesCollectionView.topAnchor.constraint(equalTo: addNewCategoryLogo.bottomAnchor, constant:
                                               UIConstants.CategoriesCollectionView.top).isActive = true
        categoriesCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant:
                                               UIConstants.CategoriesCollectionView.horizontally).isActive = true
        categoriesCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant:
                                               -UIConstants.CategoriesCollectionView.horizontally).isActive = true
        categoriesCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

extension CategoriesView: CategoriesViewTaps {
    @objc
    func didTapSortCategoriesLogo() {
        let alertController = UIAlertController(title: "Сортировка категорий",
                                                message: "Выберите в каком порядке отобразить категории",
                                                preferredStyle: .actionSheet)

        let recentlyAddedAction = UIAlertAction(title: "Недавно добавленные", style: .default) { [weak self] _ in
            self?.delegate?.sortByDateCreation()
        }

        let byNameAction = UIAlertAction(title: "Названию", style: .default) { [weak self] _ in
            self?.delegate?.sortCategoryByName()
        }

        let cancelAction = UIAlertAction(title: "Вернуться", style: .cancel, handler: nil)

        alertController.addAction(recentlyAddedAction)
        alertController.addAction(byNameAction)
        alertController.addAction(cancelAction)
        delegate?.presentViewController(alertController)
    }

    @objc
    func didTapAddNewCategoryLogo() {
        //открытие AddNewWordVC
    }
}

// MARK: - Constants
private extension CategoriesView {
    struct Consts {
        static let titleText: String = "Категории"
    }

    struct Icons {
        static let addImage = UIImage(named: "AddIconImage")
        static let sortImage = UIImage(named: "SortIconImage")
    }

    // swiftlint:disable nesting
    struct UIConstants {
        struct TitleLabel {
            static let leading: CGFloat = 18.0
            static let width: CGFloat = 120.0
        }

        struct AddNewCategoryLogo {
            static let trailing: CGFloat = 18.0
            static let size: CGFloat = 35.0
        }

        struct SortCategoriesLogo {
            static let trailing: CGFloat = 18.0
            static let size: CGFloat = 35.0
        }

        struct CategoriesCollectionView {
            static let top: CGFloat = 10.0
            static let horizontally: CGFloat = 18.0
        }
    }
}
// swiftlint:enable nesting
