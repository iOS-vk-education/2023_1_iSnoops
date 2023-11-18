//
//  CatalogViewController.swift
//  easyLanguage
//
//  Created by Grigoriy on 24.10.2023.
//  Главный экран, в котором прогресс и 2 коллекции: топ5 слов и категории.

import UIKit

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
        setup()
        setProgressView()
        setTopFiveView()
        setCategoriesView()

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

    func setup() {
        title = "Слова"
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
        progressView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 18).isActive = true
        progressView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 18).isActive = true
        progressView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -18).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        progressView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -36).isActive = true
        progressView.setupAllWords(count: 120) // должна с бека сумма всех слов приходить
        progressView.setupWordsInProgress(count: 60)
    }

    func setTopFiveView() {
        topFiveView.translatesAutoresizingMaskIntoConstraints = false
        topFiveView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 18).isActive = true
        topFiveView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 18).isActive = true
        topFiveView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        topFiveView.heightAnchor.constraint(equalToConstant: 189).isActive = true
    }

    func setCategoriesView() {
        categoriesView.translatesAutoresizingMaskIntoConstraints = false
        categoriesView.topAnchor.constraint(equalTo: topFiveView.bottomAnchor, constant: 18).isActive = true
        categoriesView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        categoriesView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        categoriesView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        let constant: CGFloat = topFiveView.frame.maxY + 18
        + CGFloat((view.frame.width / 2 - 27 + 19) * CGFloat(categoryModel.count / 2) + 45)
        categoriesView.heightAnchor.constraint(equalToConstant: constant).isActive = true
    }
}

protocol InputCategories: AnyObject {
    var categoriesCount: Int { get }
    func item(at index: Int, completion: @escaping (CategoryUIModel) -> Void)
}

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
