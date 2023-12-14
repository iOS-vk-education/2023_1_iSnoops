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
    func setupAllLearnedWords()
    func setupWordsInProgress()
    func setProgress()
}

class CatalogViewController: CustomViewController {
    private let imageManager = ImageManager.shared
    private let model = CatalogModel()
    private var categoryModel: [CategoryModel] = []
    private var topFiveModel: [TopFiveWordsModel] = [TopFiveWordsModel]()

    private let scrollView = UIScrollView()
    private let progressView = ProgressView()
    private lazy var topFiveView: TopFiveView = TopFiveView(inputTopFiveWords: self)
    private lazy var categoriesView: CategoriesView = CategoriesView(inputCategories: self)

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
        setupAllLearnedWords()
        setupWordsInProgress()
        setProgress()
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
                self.categoryModel = data
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
                                          constant: UIConstants.ProgressView.padding).isActive = true
        progressView.leftAnchor.constraint(equalTo: scrollView.leftAnchor,
                                           constant: UIConstants.ProgressView.padding).isActive = true
        progressView.rightAnchor.constraint(equalTo: scrollView.rightAnchor,
                                            constant: -UIConstants.ProgressView.padding).isActive = true
        progressView.widthAnchor.constraint(equalTo: scrollView.widthAnchor,
                                            constant: -UIConstants.ProgressView.padding * 2).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: view.frame.height / 12).isActive = true
    }

    func setTopFiveView() {
        topFiveView.translatesAutoresizingMaskIntoConstraints = false
        topFiveView.topAnchor.constraint(equalTo: progressView.bottomAnchor,
                                         constant: UIConstants.TopFiveView.top).isActive = true
        topFiveView.leftAnchor.constraint(equalTo: scrollView.leftAnchor,
                                          constant: UIConstants.TopFiveView.left).isActive = true
        topFiveView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        topFiveView.heightAnchor.constraint(equalToConstant: view.frame.height / 4.5).isActive = true
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
        let cellHeight = CGFloat(view.frame.width / 2 - 9) // -18 ( + 18 (minimumLineSpacing)
        let categoriesMargin = CGFloat(35 + 10) // 35 - высота addIcon + её отсутуп до коллекции
        let marginHeight = cellHeight * cellCount + categoriesMargin
        categoriesView.heightAnchor.constraint(equalToConstant: marginHeight).isActive = true
    }
}
// MARK: - UIConstants
// swiftlint:disable nesting
private extension CatalogViewController {
    struct UIConstants {
        struct ProgressView {
            static let padding: CGFloat = 18.0
        }

        struct TopFiveView {
            static let top: CGFloat = 12.0
            static let left: CGFloat = 18.0
        }

        struct CategoriesView {
            static let top: CGFloat = 12.0
        }
    }
}

// MARK: - Protocol ProgressSetup
extension CatalogViewController: ProgressSetup {
    func setupAllLearnedWords() {
        progressView.setupAllLearnedWords(count: 141) // должна с бека сумма всех слов приходить
    }

    func setupWordsInProgress() {
        progressView.setupWordsInProgress(count: 5)
    }

    func setProgress() {
        progressView.setProgress()
    }
}
// swiftlint:enable nesting

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

// MARK: - Protocol InputTopFiveWordsDelegate
extension CatalogViewController: InputTopFiveWordsDelegate {
    var topFiveWordsCount: Int {
        topFiveModel.count
    }

    func item(at index: Int, completion: @escaping (TopFiveWordsModel) -> Void) {
        let topFiveWordsModel = TopFiveWordsModel(
            translations: topFiveModel[index].translations,
            level: topFiveModel[index].level
        )
        completion(topFiveWordsModel)
    }
}
