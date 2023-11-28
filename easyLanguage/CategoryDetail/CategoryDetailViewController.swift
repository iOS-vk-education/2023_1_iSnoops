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

protocol ChangeLikeStatеDelegate: AnyObject {
    func changeIsLiked(with wordId: Int)
}

final class CategoryDetailViewController: CustomViewController {
    weak var updateCountWordsDelegate: UpdateCountWordsDelegate?
    var selectedItem: Int = 0 // FIXME: создать open func для установки значений а их сделать private
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
        categoryDetailCollectionView.setupChangeLikeStatеDelegate(with: self)
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
        let wordModel = WordModel(wordId: self.wordsModel[index].wordId,
                                  linkedWordsId: self.wordsModel[index].linkedWordsId,
                                  words: self.wordsModel[index].words,
                                  isLearned: self.wordsModel[index].isLearned,
                                  createdDate: self.wordsModel[index].createdDate)
        completion(wordModel)
    }
}

// MARK: - Protocol AddNewWordDelegate
extension CategoryDetailViewController: AddNewWordDelegate {
    func createWord(with newWord: WordModel) {
        model.createWord(with: newWord) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let newDataWithId):
                self.wordsModel.append(newDataWithId)
                self.categoryDetailCollectionView.categoryDetailCollectionViewReloadData()
                self.updateCountWordsDelegate?.updateTotalCountWords(with: newDataWithId.linkedWordsId)
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension CategoryDetailViewController: ChangeLikeStatеDelegate {
    func changeIsLiked(with wordId: Int) {
        model.reloadLike(with: wordId) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let isLearned):
                guard let index = self.wordsModel.firstIndex(where: { $0.wordId == wordId }) else {
                    return
                }
                let newWordModel = WordModel(wordId: self.wordsModel[index].wordId,
                                             linkedWordsId: self.wordsModel[index].linkedWordsId,
                                             words: self.wordsModel[index].words,
                                             isLearned: isLearned,
                                             createdDate: self.wordsModel[index].createdDate)
                self.wordsModel.remove(at: index)
                self.wordsModel.insert(newWordModel, at: index)

                self.categoryDetailCollectionView.performBatchUpdates {
                    guard let cell = self.categoryDetailCollectionView.cellForItem(
                        at: IndexPath(item: index, section: 0)) as? CategoryDetailCollectionViewCell
                    else {
                        return
                    }
                    let selectedCategory = self.categoryDetailCollectionView.inputWords?.selectedCategory ?? 0
                    cell.cellConfigure(with: selectedCategory, wordModel: newWordModel)
                }

                if isLearned {
                    self.updateCountWordsDelegate?.updateLearnedCountWordsAdd(with: newWordModel.linkedWordsId)
                } else {
                    self.updateCountWordsDelegate?.updateLearnedCountWordsSubtract(with: newWordModel.linkedWordsId)
                }

            case .failure(let error):
                print(error)
            }
        }
    }
}
