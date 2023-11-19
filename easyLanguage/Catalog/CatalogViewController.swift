//
//  CatalogViewController.swift
//  easyLanguage
//
//  Created by Grigoriy on 24.10.2023.
//  Главный экран, в котором прогресс и 2 коллекции: топ5 слов и категории.

import UIKit

protocol InputCategories: AnyObject {
    var categoriesCount: Int { get }
    func item(at index: Int, completion: @escaping (CategoryUIModel) -> Void)
}

class CatalogViewController: CustomViewController {
    private let imageManager = ImageManager.shared
    private let model = CatalogModel()
    private var categoryModel: [CategoryModel] = []

    private let scrollView = UIScrollView()
    private let progressView = ProgressView()
    private let topFiveView = TopFiveView()
    private lazy var categoriesView: CategoriesView = CategoriesView(inputCategories: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
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
                                    totalWordsCount: category.totalWordsCount)
                }
                self.categoryModel = categoryModel
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
        categoriesView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true

        let isEvenCount = categoryModel.count % 2 == 0
        let cellCount = CGFloat(isEvenCount ? categoryModel.count / 2 : (categoryModel.count + 1) / 2)
        let cellHeight = CGFloat(view.frame.width / 2 - 9 - 18 + UIScreen.main.bounds.width / 20.5)
        let categoriesMargin = CGFloat(35 + 10) // 35 - высота картинки (add) + её отсутуп до коллекции
        let marginHeight = cellHeight * cellCount + categoriesMargin
        categoriesView.heightAnchor.constraint(equalToConstant: marginHeight).isActive = true

    }

    func setupAllLeanedWords() {
        progressView.setupAllWords(count: 120) // должна с бека сумма всех слов приходить
    }

    func setupWordsInProgress() {
        progressView.setupWordsInProgress(count: 60)
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

extension CatalogViewController: InputCategories {
    var categoriesCount: Int {
        categoryModel.count
    }

    func item(at index: Int, completion: @escaping (CategoryUIModel) -> Void) {
        let group = DispatchGroup()

        group.enter()
        var image: UIImage?
        guard let url = URL(string: categoryModel[index].imageLink) else {
            completion(CategoryUIModel())
            return
        }

        imageManager.loadImage(from: url) { result in
            switch result {
            case .success(let data):
                image = UIImage(data: data)
            case .failure(let error):
                print(error)
            }
            group.leave()
        }

        group.notify(queue: .main) {
            let categoryUIModel = CategoryUIModel(
                categoryId: self.categoryModel[index].categoryId,
                title: self.categoryModel[index].title,
                image: image,
                studiedWordsCount: self.categoryModel[index].studiedWordsCount,
                totalWordsCount: self.categoryModel[index].totalWordsCount
            )

            completion(categoryUIModel)
        }
    }
}
