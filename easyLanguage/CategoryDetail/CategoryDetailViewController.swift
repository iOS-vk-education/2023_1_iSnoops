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

protocol CategoryDetailOutput {
    func addNewWordButtonTapped()
}

final class CategoryDetailViewController: CustomViewController {
    private lazy var collectionView = CategoryDetailCollectionView(inputWords: self)
    private var wordsModel = [WordUIModel]()
    private let model = CategoryDetailModel()
    private var linkedWordsId = MockData.categoryModel[2].linkedWordsId //FIXME: - будут данные из ячейки catalogVC
    private var selectedCategory = 2 //FIXME: - будут данные из ячейки catalogVC

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)

        loadWords()
        setNavBar()
        setCollectionView()
    }
}

// MARK: - open methods
extension CategoryDetailViewController {
    func set(linkedWordsId: String) {
        self.linkedWordsId = linkedWordsId
    }
}

// MARK: - networking
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
}

// MARK: - private methods
private extension CategoryDetailViewController {
    func setNavBar() {
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                 style: .done,
                                                 target: self,
                                                 action: #selector(addNewWordButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    func setCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                     constant: UIConstants.horizontally).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                     constant: -UIConstants.horizontally).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

// MARK: - Constants
private extension CategoryDetailViewController {
    struct UIConstants {
        static let horizontally: CGFloat = 18.0
    }
}

// MARK: - Protocol InputWordsDelegate
extension CategoryDetailViewController: InputWordsDelegate {
    var index: Int {
        selectedCategory
    }

    var wordsCount: Int {
        wordsModel.count
    }

    func item(at index: Int, completion: @escaping (WordUIModel) -> Void) {
        let wordModel = WordUIModel(categoryId: wordsModel[index].categoryId,
                                    translations: wordsModel[index].translations,
                                    isLearned: wordsModel[index].isLearned,
                                    id: wordsModel[index].id)
        completion(wordModel)
    }
}

// MARK: - CategoryDetailOutput
extension CategoryDetailViewController: CategoryDetailOutput {
    @objc
    func addNewWordButtonTapped() {
        // добавление нового слова (AddNewWordVC)
    }
}
