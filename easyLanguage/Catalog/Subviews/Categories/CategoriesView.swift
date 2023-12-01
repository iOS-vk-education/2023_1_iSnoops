//
//  CategoriesView.swift
//  easyLanguage
//
//  Created by Grigoriy on 26.10.2023.
//

import UIKit

protocol AddNewCategoryDelegate: AnyObject {
    func createCategory(with newCategory: CategoryUIModel)
}

final class CategoriesView: UIView {
    private let titleLabel: UILabel = UILabel()
    private let addNewCategoryLogo: UIImageView = UIImageView()
    private let sortCategoriesLogo: UIImageView = UIImageView()
    weak var inputCategories: InputCategoriesDelegate?
    private let categoriesCollectionView = CategoriesCollectionView()
    weak var delegate: CategoriesViewDelegate?
    weak var updateCountWordsDelegate: UpdateCountWordsDelegate?

    init(inputCategories: InputCategoriesDelegate,
         delegate: CategoriesViewDelegate,
         updateCountWordsDelegate: UpdateCountWordsDelegate?,
         navigationController: UINavigationController) {

        super.init(frame: .zero)

        self.inputCategories = inputCategories
        self.delegate = delegate
        self.updateCountWordsDelegate = updateCountWordsDelegate
        self.categoriesCollectionView.setupNavigationController(navigationController)

        categoriesCollectionView.setupInputCategoriesDelegate(with: inputCategories)
        categoriesCollectionView.setupUpdateCountWordsDelegate(with: updateCountWordsDelegate)
        setVisualAppearance()
        [categoriesCollectionView, titleLabel, addNewCategoryLogo, sortCategoriesLogo].forEach {
            self.addSubview($0)
        }
        setTitleLabel()
        setAddImageView()
        setSortImageView()
        setCategoriesCollectionView()
        setupAddNewCategoryLogoTapGesture()
        setupSortCategoriesLogoTapGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - open methods
extension CategoriesView {
    func reloadItems(at indexPath: IndexPath) {
        categoriesCollectionView.reloadItems(at: [indexPath])
    }

    func insertItems(at indexPath: IndexPath) {
        categoriesCollectionView.insertItems(at: [indexPath])
    }

    func categoriesCount() -> Int {
        categoriesCollectionView.inputCategories?.categoriesCount ?? 0
    }

    func updateCollectionView(with categoryModel: [CategoryModel]) {
        let indexPathsToUpdate = (0..<categoryModel.count).map { IndexPath(item: $0, section: 0) }
        // performBatchUpdates - для атомарного обновления (одна неделимая единица)
        categoriesCollectionView.performBatchUpdates({
            for newIndex in indexPathsToUpdate {
                // Обновление данных в ячейках
                if let cell = categoriesCollectionView.cellForItem(at: newIndex) as? CategoryCollectionViewCell {
                    categoriesCollectionView.inputCategories?
                        .item(at: newIndex.item) { categoryUIModel in
                        cell.cellConfigure(with: categoryUIModel, at: newIndex.item)
                    }
                }
            }
        })
    }
}

// MARK: - private methods
private extension CategoriesView {
    @objc
    func didTapAddNewCategoryLogo() {
        let presentedController = AddCategoryViewController(delegate: self)
        if let sheet = presentedController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        delegate?.presentViewController(presentedController)
    }

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

    func setupAddNewCategoryLogoTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapAddNewCategoryLogo))
        addNewCategoryLogo.isUserInteractionEnabled = true
        addNewCategoryLogo.addGestureRecognizer(tapGesture)
    }

    func setupSortCategoriesLogoTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSortCategoriesLogo))
        sortCategoriesLogo.isUserInteractionEnabled = true
        sortCategoriesLogo.addGestureRecognizer(tapGesture)
    }

    func setVisualAppearance() {
        titleLabel.text = CategoriesView.Consts.titleText
        titleLabel.textColor = .black
        addNewCategoryLogo.image = CategoriesView.Icons.addImage
        sortCategoriesLogo.image = CategoriesView.Icons.sortImage
    }

    func setTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: topAnchor,
                                        constant: UIConstants.TitleLabel.top).isActive = true
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
                                                    UIConstants.AddNewCategoryLogo.width).isActive = true
        addNewCategoryLogo.heightAnchor.constraint(equalToConstant:
                                                    UIConstants.AddNewCategoryLogo.height).isActive = true
    }

    func setSortImageView() {
        sortCategoriesLogo.translatesAutoresizingMaskIntoConstraints = false
        sortCategoriesLogo.topAnchor.constraint(equalTo: topAnchor).isActive = true
        sortCategoriesLogo.trailingAnchor.constraint(equalTo: addNewCategoryLogo.leadingAnchor, constant:
                                                    -UIConstants.SortCategoriesLogo.trailing).isActive = true
        sortCategoriesLogo.widthAnchor.constraint(equalToConstant:
                                                    UIConstants.SortCategoriesLogo.width).isActive = true
        sortCategoriesLogo.heightAnchor.constraint(equalToConstant:
                                                    UIConstants.SortCategoriesLogo.height).isActive = true
    }

    func setCategoriesCollectionView() {
        categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        categoriesCollectionView.topAnchor.constraint(equalTo: addNewCategoryLogo.bottomAnchor, constant:
                                                        UIConstants.CategoriesCollectionView.top).isActive = true
        categoriesCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant:
                                               UIConstants.CategoriesCollectionView.leading).isActive = true
        categoriesCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant:
                                               -UIConstants.CategoriesCollectionView.trailing).isActive = true
        categoriesCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
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
            static let top: CGFloat = 6.0
            static let leading: CGFloat = 18.0
            static let width: CGFloat = 120.0
        }

        struct AddNewCategoryLogo {
            static let trailing: CGFloat = 18.0
            static let width: CGFloat = 35.0
            static let height: CGFloat = 35.0
        }

        struct SortCategoriesLogo {
            static let trailing: CGFloat = 18.0
            static let width: CGFloat = 35.0
            static let height: CGFloat = 35.0
        }

        struct CategoriesCollectionView {
            static let top: CGFloat = 10.0
            static let leading: CGFloat = 18.0
            static let trailing: CGFloat = 18.0
        }
    }
}
// swiftlint:enable nesting

// MARK: - Protocol BottomSheetDelegate
extension CategoriesView: AddNewCategoryDelegate {
    func createCategory(with newCategory: CategoryUIModel) {
        delegate?.createCategory(with: newCategory)
    }
}
