//
//  CategoriesViewController.swift
//  easyLanguage
//
//  Created by Grigoriy on 13.12.2023.
//

import UIKit
import CoreData

struct UpdateCountWordsParameters {
    let linkedWordsId: String
    let changeTotalCount: Bool
    let changeLearnedCount: Bool
    let isLearned: Bool
    let isDeleted: Bool
}

protocol InputCategoriesDelegate: AnyObject {
    var categoriesCount: Int { get }
    func getCatalogModel(with index: Int) -> CategoryModel
    func item(at index: Int, completion: @escaping (CategoryUIModel) -> Void)
    func showActionSheet(with id: String)
}

protocol CategoriesViewControllerOutput {
    func tapAddCategory()
    func tapSortCategory()
}

final class CategoriesViewController: UIViewController {

    private var categorieseOutputDelegate: CategorieseOutputDelegate?
    private let imageManager = ImageManager.shared
    private let model = CategoriesModel()
    private var categoryModel: [CategoryModel] = []
    private let coreData = CoreDataService()

    private let titleLabel: UILabel = UILabel()
    private let addNewCategoryLogo: UIImageView = UIImageView()
    private let sortCategoriesLogo: UIImageView = UIImageView()
    private let collectionView = CategoriesCollectionView()

    init(categorieseOutputDelegate: CategorieseOutputDelegate?, navigationController: UINavigationController?) {
        super.init(nibName: nil, bundle: nil)
        self.categorieseOutputDelegate = categorieseOutputDelegate
        collectionView.setNavigationController(navigationController ?? UINavigationController())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CategoriesViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

//        loadCategories()
        loadFromCoreData()

        setAppearance()
        [collectionView, titleLabel, addNewCategoryLogo, sortCategoriesLogo].forEach {
            view.addSubview($0)
        }
        view.backgroundColor = .PrimaryColors.Background.background

        addConstraints()
        collectionView.setupInputCategoriesDelegate(with: self)
        collectionView.categoryDetailOutput = self
    }
}

// MARK: - Internal

extension CategoriesViewController {
    func calculateCategoriesCollectionViewHeight() -> CGFloat {
        let isEvenCount = categoryModel.count % 2 == 0
        let cellCount = CGFloat(isEvenCount ? categoryModel.count / 2 : (categoryModel.count + 1) / 2)
        let cellHeight = CGFloat(view.frame.width / 2 - 9) // -18 ( + 18 (minimumLineSpacing)
        let categoriesMargin = CGFloat(35 + 10) // 35 - высота addIcon + её отсутуп до коллекции
        return cellHeight * cellCount + categoriesMargin
    }
}

// MARK: - CoreData

extension CategoriesViewController {
    func loadFromCoreData() {
        categoryModel = model.loadCDCategories()

        DispatchQueue.main.async {
            self.categorieseOutputDelegate?.reloadHeight()
            self.collectionView.reloadData()
        }
    }
}

// MARK: - Networking

private extension CategoriesViewController {
    func loadCategories() {
        model.loadCategories { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let categories):
                self.categoryModel = categories
                self.categorieseOutputDelegate?.reloadHeight()
                self.collectionView.reloadData()
            case .failure(let error):
                AlertManager.showDataLoadErrorAlert(on: self)
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - set appearance elements
private extension CategoriesViewController {
    func setAppearance() {
        configureTitleLabel()
        configureSortCategoriesLogo()
        configureAddNewCategoryLogo()
    }

    func configureTitleLabel() {
        titleLabel.text = NSLocalizedString("сategoriesTitle", comment: "")
        titleLabel.textColor = .PrimaryColors.Font.header
        titleLabel.font = TextStyle.bodyBig.font
    }

    func configureSortCategoriesLogo() {
        sortCategoriesLogo.image = UIImage(named: "SortIconImage")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapSortCategory))
        sortCategoriesLogo.isUserInteractionEnabled = true
        sortCategoriesLogo.addGestureRecognizer(tapGesture)
    }

    func configureAddNewCategoryLogo() {
        addNewCategoryLogo.image = UIImage(named: "AddIconImage")
        addNewCategoryLogo.isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapAddCategory))
        addNewCategoryLogo.addGestureRecognizer(recognizer)
    }
}

// MARK: - set constraints
private extension CategoriesViewController {
    func addConstraints() {
        setTitleLabel()
        setAddImageView()
        setSortImageView()
        setCollectionView()
    }

    func setTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
    }

    func setAddImageView() {
        addNewCategoryLogo.translatesAutoresizingMaskIntoConstraints = false
        addNewCategoryLogo.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        addNewCategoryLogo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:
                                                    -UIConstants.CategoriesLogo.trailing).isActive = true
        addNewCategoryLogo.widthAnchor.constraint(equalToConstant:
                                                    UIConstants.CategoriesLogo.size).isActive = true
        addNewCategoryLogo.heightAnchor.constraint(equalToConstant:
                                                    UIConstants.CategoriesLogo.size).isActive = true
    }

    func setSortImageView() {
        sortCategoriesLogo.translatesAutoresizingMaskIntoConstraints = false
        sortCategoriesLogo.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        sortCategoriesLogo.trailingAnchor.constraint(equalTo: addNewCategoryLogo.leadingAnchor, constant:
                                                    -UIConstants.CategoriesLogo.trailing).isActive = true
        sortCategoriesLogo.widthAnchor.constraint(equalToConstant:
                                                    UIConstants.CategoriesLogo.size).isActive = true
        sortCategoriesLogo.heightAnchor.constraint(equalToConstant:
                                                    UIConstants.CategoriesLogo.size).isActive = true
    }

    func setCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: addNewCategoryLogo.bottomAnchor,
                                               constant: 10).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:
                                               UIConstants.CategoriesCollectionView.horizontally).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:
                                               -UIConstants.CategoriesCollectionView.horizontally).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

// MARK: - constants
private extension CategoriesViewController {
    // swiftlint:disable nesting
    struct UIConstants {
        struct CategoriesLogo {
            static let trailing: CGFloat = 18.0
            static let size: CGFloat = 35.0
        }

        struct CategoriesCollectionView {
            static let horizontally: CGFloat = 18.0
        }
    }
}
// swiftlint:enable nesting

// MARK: - InputCategoriesDelegate
extension CategoriesViewController: InputCategoriesDelegate {
    func showActionSheet(with id: String) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        addActionToDeleteWord(with: id, to: alertController)
        addActionToCancel(to: alertController)

        present(alertController, animated: true, completion: nil)
    }

    func getCatalogModel(with index: Int) -> CategoryModel {
        return categoryModel[index]
    }

    var categoriesCount: Int {
        categoryModel.count
    }

    func item(at index: Int, completion: @escaping (CategoryUIModel) -> Void) {
        if let imageData = categoryModel[index].imageData {
            completion(CategoryUIModel(
                title: categoryModel[index].title,
                image: UIImage(data: imageData),
                studiedWordsCount: categoryModel[index].studiedWordsCount,
                totalWordsCount: categoryModel[index].totalWordsCount,
                index: categoryModel[index].index ?? 0,
                linkedWordsId: categoryModel[index].linkedWordsId)
            )
            return
        }

        guard let imageLink = categoryModel[index].imageLink,
              let url = URL(string: imageLink) else {
            completion(CategoryUIModel())
            return
        }

        imageManager.loadImage(from: url) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let data):
                completion(
                    CategoryUIModel(
                        title: self.categoryModel[index].title,
                        image: UIImage(data: data),
                        studiedWordsCount: self.categoryModel[index].studiedWordsCount,
                        totalWordsCount: self.categoryModel[index].totalWordsCount,
                        index: self.categoryModel[index].index ?? 0,
                        linkedWordsId: self.categoryModel[index].linkedWordsId
                    )
                )
            case .failure(let error):
                AlertManager.showDataLoadErrorAlert(on: self)
                print(error)
            }
        }
    }
}

// MARK: - Actions

private extension CategoriesViewController {
     func addActionToDeleteWord(with id: String, to alertController: UIAlertController) {
        let deleteAction = UIAlertAction(title: NSLocalizedString("categoryDelete", comment: ""),
                                         style: .destructive) { _ in
//            self.handleDeleteCategory(with: id)
            self.deleteCategoryFromCoreData(with: id)
        }

        alertController.addAction(deleteAction)
    }

    func deleteCategoryFromCoreData(with id: String) {
        do {
            try coreData.deleteCategory(with: id)
            categoryModel.removeAll(where: { $0.linkedWordsId == id })
            DispatchQueue.main.async {
                self.categorieseOutputDelegate?.reloadHeight()
                self.collectionView.reloadData()
            }
        } catch {
            AlertManager.showAlert(on: self, title: "Error with deleting category", message: nil)
        }
    }

    func handleDeleteCategory(with id: String) {
        model.deleteCategory(with: id) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let isDeleted):
                if isDeleted {
                    categoryModel.removeAll(where: { $0.linkedWordsId == id })
                    self.categorieseOutputDelegate?.reloadHeight()
                    collectionView.reloadData()
                } else {
                    AlertManager.showWordDeleteAlert(on: self)
                }
            case .failure(let error):
                AlertManager.showWordDeleteAlert(on: self)
                print(error.localizedDescription)
            }
        }
    }

    func addActionToCancel(to alertController: UIAlertController) {
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel) { _ in }
        alertController.addAction(cancelAction)
    }
}

// MARK: - CategoriesViewControllerOutput
extension CategoriesViewController: CategoriesViewControllerOutput {
    @objc
    func tapAddCategory() {
        let addCategoryVC = AddNewCategoryViewController()
        addCategoryVC.modalPresentationStyle = .pageSheet
        addCategoryVC.delegate = self

        guard let sheet = addCategoryVC.sheetPresentationController else {
            return
        }

        sheet.preferredCornerRadius = 25
        sheet.prefersGrabberVisible = true
        sheet.detents = [.medium()]

        present(addCategoryVC, animated: true, completion: nil)
    }

    @objc
    func tapSortCategory() {
        let alertController = UIAlertController(
            title: NSLocalizedString("sortTitle", comment: ""),
            message: nil,
            preferredStyle: .actionSheet
        )

        let recentlyAddedAction = UIAlertAction(title: NSLocalizedString("sortRecentlyAdded", comment: ""),
                                                style: .default) { [weak self] _ in
            self?.sortByDateCreation()
        }

        let byNameAction = UIAlertAction(title: NSLocalizedString("sortByName", comment: ""),
                                         style: .default) { [weak self] _ in
            self?.sortCategoryByName()
        }

        let cancelAction = UIAlertAction(title: NSLocalizedString("sortCancel", comment: ""),
                                         style: .cancel, handler: nil)

        alertController.addAction(recentlyAddedAction)
        alertController.addAction(byNameAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }

    private func sortByDateCreation() {
        categoryModel.sort {
            $0.createdDate > $1.createdDate
        }
        updateCollectionView(with: categoryModel)
    }

    private func sortCategoryByName() {
        categoryModel.sort {
            $0.title < $1.title
        }
        updateCollectionView(with: categoryModel)
    }

    private func updateCollectionView(with categoryModel: [CategoryModel]) {
        let indexPathsToUpdate = (0..<categoryModel.count).map { IndexPath(item: $0, section: 0) }
        // performBatchUpdates - для атомарного обновления (одна неделимая единица)
        collectionView.performBatchUpdates({
            for newIndex in indexPathsToUpdate {
                // Обновление данных в ячейках
                if let cell = collectionView.cellForItem(at: newIndex) as? CategoryCollectionViewCell {
                    collectionView.inputCategories?.item(at: newIndex.item) { categoryUIModel in
                        cell.cellConfigure(with: categoryUIModel, at: newIndex)
                    }
                }
            }
        })
    }
}

extension CategoriesViewController: AddNewCategoryOutput {
    func isCategoryExist(with title: String) -> Bool {
        categoryModel.contains { $0.title == title }
    }

    func categoryDidAdded(with categoryModel: CategoryModel) {
        DispatchQueue.main.async {

            self.categoryModel.append(CategoryModel(title: categoryModel.title,
                                                    imageLink: categoryModel.imageLink,
                                                    imageData: categoryModel.imageData,
                                                    studiedWordsCount: categoryModel.studiedWordsCount,
                                                    totalWordsCount: categoryModel.totalWordsCount,
                                                    createdDate: categoryModel.createdDate,
                                                    linkedWordsId: categoryModel.linkedWordsId,
                                                    index: self.categoryModel.count + 1,
                                                    isDefault: false))

            self.categorieseOutputDelegate?.reloadHeight()
            self.collectionView.reloadData()
        }
    }
}

extension CategoriesViewController: CategoryDetailOutput {
    func updateCountWords(with parameters: UpdateCountWordsParameters) {
        if let index = categoryModel.firstIndex(where: { $0.linkedWordsId == parameters.linkedWordsId }) {
            if parameters.changeTotalCount {
                categoryModel[index].totalWordsCount += parameters.isDeleted ? -1 : 1
            }

            if parameters.changeLearnedCount {
                categoryModel[index].studiedWordsCount += parameters.isLearned ? 1 : -1
            }

            let indexPath = IndexPath(item: index, section: 0)
            collectionView.reloadItems(at: [indexPath])
        }
    }
}
