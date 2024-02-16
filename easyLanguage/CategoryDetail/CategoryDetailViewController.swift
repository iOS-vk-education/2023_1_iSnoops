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
    func changeIsLearned(with number: Int, isLearned: Bool)
    func showAlert(with id: String)
}

protocol CategoryDetailOutput: AnyObject {
    func updateCountWords(with linkedWordsId: String,
                          changeTotalCount: Bool,
                          changeLearnedCount: Bool,
                          isLearned: Bool,
                          isDeleted: Bool
    )
}

final class CategoryDetailViewController: CustomViewController {
    private lazy var collectionView = CategoryDetailCollectionView(inputWords: self)
    private var wordsModel = [WordUIModel]()
    private let model = CategoryDetailModel()
    private var selectedCategory = 0
    private var linkedWordsId = ""
    weak var delegate: CategoryDetailOutput?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)

        loadWords()
        setNavBar()
        setCollectionView()
    }

    @objc
    func tappedAddWord() {
        let addCategoryVC = AddNewWordViewController()
        addCategoryVC.modalPresentationStyle = .pageSheet
        addCategoryVC.setCategoryId(with: linkedWordsId)
        addCategoryVC.delegate = self

        guard let sheet = addCategoryVC.sheetPresentationController else {
            return
        }

        sheet.preferredCornerRadius = 25
        sheet.prefersGrabberVisible = true
        sheet.detents = [.medium()]

        present(addCategoryVC, animated: true, completion: nil)
    }
}

// MARK: - open methods
extension CategoryDetailViewController {
    func set(with category: CategoryModel) {
        self.selectedCategory = category.index ?? 0
        self.linkedWordsId = category.linkedWordsId

        seTitle(with: category.title)
    }

    private func seTitle(with title: String) {
        self.title = title
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
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                AlertManager.showDataLoadErrorAlert(on: self)
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
                                                 action: #selector(tappedAddWord))
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

    func changeIsLearned(with number: Int, isLearned: Bool) {
        model.reloadIsLearned(with: wordsModel[number].id, isLearned: isLearned)

        self.delegate?.updateCountWords(with: wordsModel[number].categoryId,
                                        changeTotalCount: false,
                                        changeLearnedCount: true,
                                        isLearned: isLearned,
                                        isDeleted: false
                                        )
    }

    func showAlert(with id: String) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        // FIXME: - change title
        let deleteAction = UIAlertAction(title: "Delete Word", style: .destructive) { [weak self] _ in
            guard let self else { return }
            self.model.deleteWord(with: id, comletion: { result in
                switch result {
                case .success:
                    guard let index = self.wordsModel.firstIndex(where: { $0.id == id }) else {
                        print("не найдено слово :(")
                        return
                    }
                    let categoryId = self.wordsModel[index].categoryId
                    let isLearned = self.wordsModel[index].isLearned

                    DispatchQueue.main.async {
                        self.delegate?.updateCountWords(with: categoryId,
                                                        changeTotalCount: true,
                                                        changeLearnedCount: isLearned,
                                                        isLearned: false,
                                                        isDeleted: true
                                                        )
                        self.wordsModel.removeAll(where: { $0.id == id })
                        self.collectionView.reloadData()
                    }
                case .failure(let error):
                    // TODO: - add alert
                    print(error.localizedDescription)
                }
            })
        }

        // FIXME: - change title
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
        }

        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension CategoryDetailViewController: AddNewWordOutput {
    func didCreateWord(with categoryId: String) {
        loadWords()
        delegate?.updateCountWords(with: categoryId,
                                        changeTotalCount: true,
                                        changeLearnedCount: false,
                                        isLearned: false,
                                        isDeleted: false
                                        )
    }
}
