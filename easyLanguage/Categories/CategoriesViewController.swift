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

protocol CategoriesViewControllerOutput {
    func tapAddCategory()
    func tapSortCategory()
}

final class CategoriesViewController: UIViewController {
    private var indexCache: [Int: Int] = [:]

    private var categorieseOutputDelegate: CategorieseOutputDelegate?
    private let imageManager = ImageManager.shared
    private let model = CategoriesModel()
    private var categoryModel: [CategoryModel] = []

    private let titleLabel: UILabel = UILabel()
    private let addNewCategoryLogo: UIImageView = UIImageView()
    private let sortCategoriesLogo: UIImageView = UIImageView()
    private let categoriesCollectionView = CategoriesCollectionView()

    init(categorieseOutputDelegate: CategorieseOutputDelegate?) {
        super.init(nibName: nil, bundle: nil)
        self.categorieseOutputDelegate = categorieseOutputDelegate
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CategoriesViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()

        setAppearance()
        [categoriesCollectionView, titleLabel, addNewCategoryLogo, sortCategoriesLogo].forEach {
            view.addSubview($0)
        }
        view.backgroundColor = .PrimaryColors.Background.background

        addConstraints()
        categoriesCollectionView.setupInputCategoriesDelegate(with: self)
    }
}

// MARK: - internal func
extension CategoriesViewController {
    func calculateCategoriesCollectionViewHeight() -> CGFloat {
        let isEvenCount = categoryModel.count % 2 == 0
        let cellCount = CGFloat(isEvenCount ? categoryModel.count / 2 : (categoryModel.count + 1) / 2)
        let cellHeight = CGFloat(view.frame.width / 2 - 9) // -18 ( + 18 (minimumLineSpacing)
        let categoriesMargin = CGFloat(35 + 10) // 35 - высота addIcon + её отсутуп до коллекции
        return cellHeight * cellCount + categoriesMargin
    }
}

// MARK: - Networking
private extension CategoriesViewController {
    func loadCategories() {
        model.loadCategory { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.categoryModel = data
                    self.categorieseOutputDelegate?.reloadHeight(with: self.calculateCategoriesCollectionViewHeight())
                    self.categoriesCollectionView.reloadData()
                }
            case .failure(let error):
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
        setCategoriesCollectionView()
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

    func setCategoriesCollectionView() {
        categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        categoriesCollectionView.topAnchor.constraint(equalTo: addNewCategoryLogo.bottomAnchor,
                                               constant: 10).isActive = true
        categoriesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:
                                               UIConstants.CategoriesCollectionView.horizontally).isActive = true
        categoriesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:
                                               -UIConstants.CategoriesCollectionView.horizontally).isActive = true
        categoriesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
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
    var categoriesCount: Int {
        categoryModel.count
    }

    func item(at index: Int, completion: @escaping (CategoryUIModel) -> Void) {
        // swiftlint:disable line_length
        let defaultImageLink = "https://firebasestorage.googleapis.com/v0/b/easylanguage-e6d17.appspot.com/o/categories%2F1E1922CE-61D4-46BE-B2C7-4E12B316CCFA?alt=media&token=80174f66-ee40-4f34-9a35-8d7ed4fbd571"
        // swiftlint:enable line_length
        guard let url = URL(string: categoryModel[index].imageLink ?? defaultImageLink) else {
            completion(CategoryUIModel())
            return
        }

        imageManager.loadImage(from: url) { [weak self] result in
            switch result {
            case .success(let data):
                guard let self = self else { return }
                if let indexCache = indexCache[index] {
                    print("indexCache", indexCache, index)
                    completion(
                        CategoryUIModel(
                            title: categoryModel[indexCache].title,
                            image: UIImage(data: data),
                            studiedWordsCount: categoryModel[indexCache].studiedWordsCount,
                            totalWordsCount: categoryModel[indexCache].totalWordsCount,
                            index: indexCache
                        )
                    )
                } else {
                    print(index)
                    indexCache[index] = index
                    completion(
                        CategoryUIModel(
                            title: categoryModel[index].title,
                            image: UIImage(data: data),
                            studiedWordsCount: categoryModel[index].studiedWordsCount,
                            totalWordsCount: categoryModel[index].totalWordsCount,
                            index: index
                        )
                    )
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - CategoriesViewControllerOutput
extension CategoriesViewController: CategoriesViewControllerOutput {
    @objc
    func tapAddCategory() {
        let addCategoryVC = AddNewCategoryViewController()
        addCategoryVC.modalPresentationStyle = .pageSheet

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
        let alertController = UIAlertController(title: NSLocalizedString("sortTitle", comment: ""),
                                                message: NSLocalizedString("sortMessage", comment: ""),
                                                preferredStyle: .actionSheet)

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
        categoriesCollectionView.reloadData()
    }
}
