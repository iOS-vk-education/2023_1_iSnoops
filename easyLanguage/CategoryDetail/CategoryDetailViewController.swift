//
//  CategoryDetailViewController.swift
//  easyLanguage
//
//  Created by Grigoriy on 10.12.2023.
//
//  Экран, попадаем при нажатии на категорию. Отвечает за просмотр слов в категории и добавление новых слов

import UIKit

protocol InputWordsDelegate: AnyObject {
    var wordsCount: Int { get }
    var index: Int { get }
    func item(at index: Int, completion: @escaping (WordUIModel) -> Void)
}

protocol CategoryDetailTaps {
    func addButtonTapped()
}

final class CategoryDetailViewController: CustomViewController {
    private var categoryTitle = "EXAMPLE" //FIXME: - будут данные из ячейки catalogVC
    private var linkedWordsId = MockData.categoryModel[2].linkedWordsId //FIXME: - будут данные из ячейки catalogVC
    private var numberOfSelectedCategory = 2 //FIXME: - будут данные из ячейки catalogVC
    private lazy var categoryDetailCollectionView = CategoryDetailCollectionView(inputWords: self)
    private let model = CategoryDetailModel()
    private var wordsModel: [WordUIModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(categoryDetailCollectionView)
        loadWords()
        setCategoryDetailCollectionView()
        setNavBar()
    }
}

// MARK: - open methods
extension CategoryDetailViewController {
    func configureCategoryDetailViewController(with categoryTitle: String, linkedWordsId: String) {
        self.categoryTitle = categoryTitle
        self.linkedWordsId = linkedWordsId
    }
}

// MARK: - private methods
private extension CategoryDetailViewController {
    func loadWords() {
        model.loadWords(with: linkedWordsId) { [weak self] result in
            guard let self = self else {
                return
            }

            switch result {
            case .success(let data):
                self.wordsModel = data
            case .failure(let error):
                print("[DEBUG]: \(#function), \(error.localizedDescription)")
            }
        }
    }

    func setNavBar() {
        title = categoryTitle
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                 style: .done,
                                                 target: self,
                                                 action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    func setCategoryDetailCollectionView() {
        categoryDetailCollectionView.translatesAutoresizingMaskIntoConstraints = false
        categoryDetailCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        categoryDetailCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                     constant: UIConstants.CategoryDetailCollectionView.padding).isActive = true
        categoryDetailCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                     constant: -UIConstants.CategoryDetailCollectionView.padding).isActive = true
        categoryDetailCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension CategoryDetailViewController: CategoryDetailTaps {
    @objc
    func addButtonTapped() {
        // добавление нового слова (AddNewWordVC)
    }
}

// MARK: - Protocol InputWordsDelegate
extension CategoryDetailViewController: InputWordsDelegate {
    var index: Int {
        numberOfSelectedCategory
    }

    var wordsCount: Int {
        wordsModel.count
    }

    func item(at index: Int, completion: @escaping (WordUIModel) -> Void) {
        let wordModel = WordUIModel(categoryId: wordsModel[index].categoryId,
                                    translations: wordsModel[index].translations,
                                    isLearned: wordsModel[index].isLearned)
        completion(wordModel)
    }
}

// MARK: - Constants
// swiftlint:disable nesting
private extension CategoryDetailViewController {
    struct UIConstants {
        struct CategoryDetailCollectionView {
            static let padding: CGFloat = 18.0
        }
    }
}
// swiftlint:enable nesting
