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
}

protocol CategoryDetailOutput: AnyObject {
    func updateTotalCountWords(with linkedWordsId: String)
    func updateLearnedCountWords(with linkedWordsId: String, isLearned: Bool)
}

final class CategoryDetailViewController: CustomViewController {
    private let noWordsLabel: UILabel = {
        let label = UILabel()
        label.text =  NSLocalizedString("emptyCategoryAdvice", comment: "")
        label.textColor = .PrimaryColors.Font.secondary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var collectionView = CategoryDetailCollectionView(inputWords: self)
    private var wordsModel = [WordUIModel]()
    private let model = CategoryDetailModel()
    private var selectedCategory = 0
    private var linkedWordsId = ""
    weak var delegate: CategoryDetailOutput?

    override func viewDidLoad() {
        super.viewDidLoad()

        [collectionView, noWordsLabel].forEach {
            view.addSubview($0)
        }

        loadWords()
        setNavBar()
        setNoWordsLabel()
        setCollectionView()
    }

    @objc
    func tappedAddWord() {
        let addCategoryVC = AddWordBuilder.build(categoryID: linkedWordsId)
        addCategoryVC.modalPresentationStyle = .pageSheet
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
                if !wordsModel.isEmpty {
                    noWordsLabel.isHidden = true
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

    func setNoWordsLabel() {
        noWordsLabel.translatesAutoresizingMaskIntoConstraints = false
        noWordsLabel.topAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        noWordsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noWordsLabel.sizeToFit()
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
        delegate?.updateLearnedCountWords(with: wordsModel[number].categoryId, isLearned: isLearned)
    }
}

extension CategoryDetailViewController: AddWordOutput {
    func didCreateWord(with categoryId: String) {
        loadWords()
        delegate?.updateTotalCountWords(with: categoryId)
    }
}
