//
//  CategoryDetailViewController.swift
//  easyLanguage
//
//  Created by Grigoriy on 19.11.2023.
//  Экран, попадаем при нажатии на категорию. Отвечает за просмотр категории и добавление новых слов

import UIKit

protocol InputWordsDelegate: AnyObject {
    var wordsCount: Int { get }
    var selectedCategory: Int { get }
    func item(at index: Int, completion: @escaping (WordModel) -> Void)
}

protocol AddNewWordDelegate: AnyObject {
    func createWord(with newWord: WordModel)
}

final class CategoryDetailViewController: CustomViewController {
    var selectedItem: Int = 0
    var categoryDetailTitle = ""
    var linkedWordsId = ""
    private let categoryDetailCollectionView = CategoryDetailCollectionView()
    private let model = CategoryDetailModel()
    private var wordsModel: [WordModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(categoryDetailCollectionView)
        setCategoryDetailCollectionView()
        title = categoryDetailTitle
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                style: .done,
                                                target: self,
                                                action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        loadWords()
        categoryDetailCollectionView.setupInputWordsDelegate(with: self)
    }
}

// MARK: - private methods
private extension CategoryDetailViewController {
    func loadWords() {
        model.loadWords(with: linkedWordsId) { [weak self] result in
            guard let self = self else {
                print("[DEBUG]: \(#function) guard self error")
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

    @objc
    func addButtonTapped() {
        let presentedController = AddWordViewController(delegate: self)
        presentedController.setLinkedWordsId(with: linkedWordsId)
        if let sheet = presentedController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        present(presentedController, animated: true)
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

// MARK: - Protocol InputWordsDelegate
extension CategoryDetailViewController: InputWordsDelegate {
    var selectedCategory: Int {
        selectedItem
    }

    var wordsCount: Int {
        wordsModel.count
    }

    func item(at index: Int, completion: @escaping (WordModel) -> Void) {
        let wordModel = WordModel(linkedWordsId: self.wordsModel[index].linkedWordsId,
                                  words: self.wordsModel[index].words,
                                  isLearned: self.wordsModel[index].isLearned,
                                  createdDate: self.wordsModel[index].createdDate)
        completion(wordModel)
    }
}

// MARK: - Protocol AddNewWordDelegate
extension CategoryDetailViewController: AddNewWordDelegate {
    func createWord(with newWord: WordModel) {
        model.createWord(with: newWord, categoryId: selectedItem)
        wordsModel.append(newWord)
        categoryDetailCollectionView.categoryDetailCollectionViewReloadData()
    }
}
