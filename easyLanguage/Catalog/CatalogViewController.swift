//
//  CatalogViewController.swift
//  easyLanguage
//
//  Created by Grigoriy on 24.10.2023.
//  Главный экран, в котором прогресс и 2 коллекции: топ5 слов и категории.

import UIKit

protocol InputCategoriesDelegate: AnyObject {
    var categoriesCount: Int { get }
    func item(at index: Int, completion: @escaping (CategoryUIModel) -> Void)
}

protocol InputTopFiveWordsDelegate: AnyObject {
    var topFiveWordsCount: Int { get }
    func item(at index: Int, completion: @escaping (TopFiveWordsModel) -> Void)
}

protocol ProgressSetup {
    func setupAllLeanedWords()
    func setupWordsInProgress()
}

protocol CategoriesViewDelegate: AnyObject {
    func presentViewController(_ viewController: UIViewController)
    func sortCategoryByName()
    func sortByDateCreation()
    func createCategory(with newCategory: CategoryUIModel)
}

class CatalogViewController: CustomViewController {
    private let imageManager = ImageManager.shared
    private let model = CatalogModel()
    private var categoryModel: [CategoryModel] = []
    private var topFiveModel: [TopFiveWordsModel] = [TopFiveWordsModel]()
    private let scrollView = UIScrollView()
    private let progressView = ProgressView()
    private lazy var topFiveView: TopFiveView = TopFiveView(inputTopFiveWords: self)
    // FIXME: - возможно не надо self 2 раза передавать
    private lazy var categoriesView = CategoriesView(
                                                inputCategories: self,
                                                delegate: self,
                                                navigationController: navigationController ?? UINavigationController())
    private var categoriesViewHeightConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        loadTopFiveWords()
        view.addSubview(scrollView)
        setScrollView()
        [progressView, topFiveView, categoriesView].forEach {
            scrollView.addSubview($0)
        }
        title = "Слова"
        setProgressView()
        setTopFiveView()
        setCategoriesView()
        setupAllLeanedWords()
        setupWordsInProgress()
    }
}

// MARK: - private methods
private extension CatalogViewController {
    func loadCategories() {
        model.loadCategory { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let data):
                let categoryModel = data.map { category in
                    CategoryModel(categoryId: category.categoryId,
                                    title: category.title,
                                    imageLink: category.imageLink,
                                    studiedWordsCount: category.studiedWordsCount,
                                    totalWordsCount: category.totalWordsCount,
                                    createdDate: category.createdDate)
                }
                self.categoryModel = categoryModel
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func loadTopFiveWords() {
        model.loadTopFiveWords { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let data):
                self.topFiveModel = data
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func setScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    func setProgressView() {
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.topAnchor.constraint(equalTo: scrollView.topAnchor,
                                          constant: UIConstants.ProgressView.top).isActive = true
        progressView.leftAnchor.constraint(equalTo: scrollView.leftAnchor,
                                          constant: UIConstants.ProgressView.left).isActive = true
        progressView.rightAnchor.constraint(equalTo: scrollView.rightAnchor,
                                          constant: -UIConstants.ProgressView.right).isActive = true
        progressView.widthAnchor.constraint(equalTo: scrollView.widthAnchor,
                                          constant: -UIConstants.ProgressView.width).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: UIConstants.ProgressView.height).isActive = true
    }

    func setTopFiveView() {
        topFiveView.translatesAutoresizingMaskIntoConstraints = false
        topFiveView.topAnchor.constraint(equalTo: progressView.bottomAnchor,
                                          constant: UIConstants.TopFiveView.top).isActive = true
        topFiveView.leftAnchor.constraint(equalTo: scrollView.leftAnchor,
                                          constant: UIConstants.TopFiveView.left).isActive = true
        topFiveView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        topFiveView.heightAnchor.constraint(equalToConstant: UIConstants.TopFiveView.height).isActive = true
    }

    func setCategoriesView() {
        categoriesView.translatesAutoresizingMaskIntoConstraints = false
        categoriesView.topAnchor.constraint(equalTo: topFiveView.bottomAnchor,
                                          constant: UIConstants.CategoriesView.top).isActive = true
        categoriesView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        categoriesView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        categoriesViewHeightConstraint = categoriesView.heightAnchor
                                          .constraint(equalToConstant: calculateCategoriesViewHeight())
        categoriesViewHeightConstraint?.isActive = true
        categoriesView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }

    func calculateCategoriesViewHeight() -> CGFloat {
        let isEvenCount = categoryModel.count % 2 == 0
        let cellCount = CGFloat(isEvenCount ? categoryModel.count / 2 : (categoryModel.count + 1) / 2)
        let cellHeight = CGFloat(view.frame.width / 2 - 9 - 18 + UIScreen.main.bounds.width / 20.5)
        let categoriesMargin = CGFloat(35 + 10) // 35 - высота addIcon + её отсутуп до коллекции
        return cellHeight * cellCount + categoriesMargin
    }
}
// MARK: - UIConstants
// swiftlint:disable nesting
private extension CatalogViewController {
    struct UIConstants {
        struct ProgressView {
            static let top: CGFloat = 18.0
            static let bottom: CGFloat = 18.0
            static let left: CGFloat = 18.0
            static let right: CGFloat = 18.0
            static let width: CGFloat = 36.0
            static let height: CGFloat = 50.0
        }

        struct TopFiveView {
            static let top: CGFloat = 18.0
            static let left: CGFloat = 18.0
            static let height: CGFloat = 189.0
        }

        struct CategoriesView {
            static let top: CGFloat = 18.0
        }
    }
}
// swiftlint:enable nesting

// MARK: - Protocol ProgressSetup
extension CatalogViewController: ProgressSetup {
    func setupAllLeanedWords() {
        progressView.setupAllWords(count: 120) // должна с бека сумма всех слов приходить
    }

    func setupWordsInProgress() {
        progressView.setupWordsInProgress(count: 60)
    }
}

// MARK: - Protocol InputCategoriesDelegate
extension CatalogViewController: InputCategoriesDelegate {
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
                        title: self.categoryModel[index].title,
                        image: UIImage(data: data),
                        studiedWordsCount: self.categoryModel[index].studiedWordsCount,
                        totalWordsCount: self.categoryModel[index].totalWordsCount
                    )
                )
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - Protocol InputTopFiveWordsDelegate
extension CatalogViewController: InputTopFiveWordsDelegate {
    var topFiveWordsCount: Int {
        topFiveModel.count
    }

    func item(at index: Int, completion: @escaping (TopFiveWordsModel) -> Void) {
        let topFiveWordsModel = TopFiveWordsModel(
            topFiveWordsId: self.topFiveModel[index].topFiveWordsId,
            title: self.topFiveModel[index].title,
            level: self.topFiveModel[index].level
        )
        completion(topFiveWordsModel)
    }
}

// MARK: - Protocol CategoriesViewDelegate
extension CatalogViewController: CategoriesViewDelegate {
    func presentViewController(_ viewController: UIViewController) {
        present(viewController, animated: true)
    }

    func sortCategoryByName() {
        categoryModel.sort {
            $0.title["ru"]! < $1.title["ru"]!
        }
        categoriesView.reloadData()
    }

    func sortByDateCreation() {
        categoryModel.sort {
            $0.createdDate > $1.createdDate
        }
        categoriesView.reloadData()
    }

    func createCategory(with newCategory: CategoryUIModel) {
        // FIXME: - надо вытащить categoryId
        let newCategoryModel = CategoryModel(categoryId: 10,
                                          title: newCategory.title,
                                          imageLink: nil,
                                          studiedWordsCount: newCategory.studiedWordsCount,
                                          totalWordsCount: newCategory.totalWordsCount,
                                          createdDate: Date())
        model.createCategory(with: newCategoryModel)
        categoryModel.append(newCategoryModel)
        // FIXME: - возможно тут надо не reloadData всей коллекции а отедельной ячейки
        categoriesView.reloadData()
        updateCategoriesViewHeight()
    }

    private func updateCategoriesViewHeight() {
        categoriesViewHeightConstraint?.constant = calculateCategoriesViewHeight()
    }
}
