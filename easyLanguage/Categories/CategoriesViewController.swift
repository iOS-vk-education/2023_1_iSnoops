//
//  CategoriesViewController.swift
//  easyLanguage
//
//  Created by Grigoriy on 13.12.2023.
//

import UIKit

protocol InputCategoriesDelegate: AnyObject {
    var categoriesCount: Int { get }
    func item(at index: Int, completion: @escaping (CategoryUIModel) -> Void)
}

protocol SortCategoriesView {
    func sortByDateCreation()
    func sortCategoryByName()
}

final class CategoriesViewController: UIViewController {
    private let imageManager = ImageManager.shared
    private let model = CategoriesModel()
    private var categoryModel: [CategoryModel] = []

    private let titleLabel: UILabel = UILabel()
    private let addNewCategoryLogo: UIImageView = UIImageView()
    private let sortCategoriesLogo: UIImageView = UIImageView()
    private let categoriesCollectionView = CategoriesCollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()

        setVisualAppearance()
        [categoriesCollectionView, titleLabel, addNewCategoryLogo, sortCategoriesLogo].forEach {
            view.addSubview($0)
        }
        view.backgroundColor = .PrimaryColors.Background.background

        setTitleLabel()
        setAddImageView()
        setSortImageView()
        setCategoriesCollectionView()
        categoriesCollectionView.setupInputCategoriesDelegate(with: self)
    }
}
extension CategoriesViewController {
    func calculateCategoriesCollectionViewHeight() -> CGFloat {
        let isEvenCount = categoryModel.count % 2 == 0
        let cellCount = CGFloat(isEvenCount ? categoryModel.count / 2 : (categoryModel.count + 1) / 2)
        let cellHeight = CGFloat(view.frame.width / 2 - 9) // -18 ( + 18 (minimumLineSpacing)
        let categoriesMargin = CGFloat(35 + 10) // 35 - высота addIcon + её отсутуп до коллекции
        return cellHeight * cellCount + categoriesMargin
    }
}

// MARK: - private methods
private extension CategoriesViewController {
    func loadCategories() {
        model.loadCategory { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let data):
                self.categoryModel = data
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func setVisualAppearance() {
        titleLabel.text = "Категории"
        titleLabel.textColor = .black
        addNewCategoryLogo.image = UIImage(named: "AddIconImage")
        sortCategoriesLogo.isUserInteractionEnabled = true
        configureSortCategoriesLogo()
    }

    func configureSortCategoriesLogo() {
        sortCategoriesLogo.image = UIImage(named: "SortIconImage")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSortCategoriesLogo))
        sortCategoriesLogo.isUserInteractionEnabled = true
        sortCategoriesLogo.addGestureRecognizer(tapGesture)
    }

    func setTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                            constant: UIConstants.TitleLabel.leading).isActive = true
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

    func setCategoriesCollectionView() {
        categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        categoriesCollectionView.topAnchor.constraint(equalTo: addNewCategoryLogo.bottomAnchor, constant:
                                               UIConstants.CategoriesCollectionView.top).isActive = true
        categoriesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:
                                               UIConstants.CategoriesCollectionView.horizontally).isActive = true
        categoriesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:
                                               -UIConstants.CategoriesCollectionView.horizontally).isActive = true
        categoriesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    @objc
    func didTapSortCategoriesLogo() {
         let alertController = UIAlertController(title: "Сортировка категорий",
                                                 message: "Выберите в каком порядке отобразить категории",
                                                 preferredStyle: .actionSheet)

          let recentlyAddedAction = UIAlertAction(title: "Недавно добавленные", style: .default) { [weak self] _ in
              self?.sortByDateCreation()
          }

          let byNameAction = UIAlertAction(title: "Названию", style: .default) { [weak self] _ in
              self?.sortCategoryByName()
          }

          let cancelAction = UIAlertAction(title: "Вернуться", style: .cancel, handler: nil)

          alertController.addAction(recentlyAddedAction)
          alertController.addAction(byNameAction)
          alertController.addAction(cancelAction)
          self.present(alertController, animated: true)
     }
}

// MARK: - Protocol InputCategoriesDelegate
extension CategoriesViewController: InputCategoriesDelegate {
    var categoriesCount: Int {
        categoryModel.count
    }

    func item(at index: Int, completion: @escaping (CategoryUIModel) -> Void) {
        let defaultImageLink = "https://climate.onep.go.th/wp-content/uploads/2020/01/default-image.jpg"
        guard let url = URL(string: categoryModel[index].imageLink ?? defaultImageLink) else {
            completion(CategoryUIModel())
            return
        }

        imageManager.loadImage(from: url) { [weak self] result in
            switch result {
            case .success(let data):
                guard let self = self else { return }
                completion(
                    CategoryUIModel(
                        title: categoryModel[index].title,
                        image: UIImage(data: data),
                        studiedWordsCount: categoryModel[index].studiedWordsCount,
                        totalWordsCount: categoryModel[index].totalWordsCount
                    )
                )
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - Constants
private extension CategoriesViewController {
    // swiftlint:disable nesting
    struct UIConstants {
        struct TitleLabel {
            static let leading: CGFloat = 18.0
        }

        struct CategoriesLogo {
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

// MARK: - Protocol SortCategoriesView
extension CategoriesViewController: SortCategoriesView {
    func sortCategoryByName() {
        categoryModel.sort {
            $0.title < $1.title
        }
        updateCollectionView(with: categoryModel)
    }

    func sortByDateCreation() {
        categoryModel.sort {
            $0.createdDate > $1.createdDate
        }
        updateCollectionView(with: categoryModel)
    }

    private func updateCollectionView(with categoryModel: [CategoryModel]) {
        let indexPathsToUpdate = (0..<categoryModel.count).map { IndexPath(item: $0, section: 0) }
        // performBatchUpdates - для атомарного обновления (одна неделимая единица)
        categoriesCollectionView.performBatchUpdates({
            for newIndex in indexPathsToUpdate {
                // Обновление данных в ячейках
                if let cell = categoriesCollectionView.cellForItem(at: newIndex) as? CategoryCollectionViewCell {
                    categoriesCollectionView.inputCategories?.item(at: newIndex.item) { categoryUIModel in
                        cell.cellConfigure(with: categoryUIModel, at: newIndex)
                    }
                }
            }
        })
    }
}
