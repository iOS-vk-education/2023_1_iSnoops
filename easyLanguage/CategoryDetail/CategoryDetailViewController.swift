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
        label.text = NSLocalizedString("emptyCategoryAdvice", comment: "")
        label.textColor = .PrimaryColors.Font.secondary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var collectionView = CategoryDetailCollectionView(inputWords: self)

    private let button: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("CategoryDetailGoToStudy", comment: ""), for: .normal)
        button.backgroundColor = .PrimaryColors.Button.blue
        button.layer.cornerRadius = 16
        return button
    }()

    private var wordsModel = [WordUIModel]()
    private let model = CategoryDetailModel()
    private var selectedCategory = 0
    private var linkedWordsId = ""
    weak var delegate: CategoryDetailOutput?

    private var height: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        [collectionView, noWordsLabel, button].forEach {
            view.addSubview($0)
        }

        height =  view.bounds.height / 15

        setHeight()
        loadWords()
        setNavBar()
        setNoWordsLabel()
        setCollectionView()
        setButton()

        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
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

    @objc
    func didTapButton() {
        let learningVC = LearningViewController(isNeedLoadAll: false)
        learningVC.learnCategory(with: linkedWordsId)
        learningVC.modalPresentationStyle = .pageSheet

        present(learningVC, animated: true)
    }
}

// MARK: - internal methods
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
    func setHeight() {
        collectionView.setContentInset(with: height + 20)
    }

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
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    func setButton() {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                        constant: UIConstants.horizontally).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                         constant: -UIConstants.horizontally).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                       constant: -height * 1.5 - UIConstants.height).isActive = true
        button.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}

// MARK: - Constants
private extension CategoryDetailViewController {
    struct UIConstants {
        static let horizontally: CGFloat = 36.0
        static let height: CGFloat = 10.0
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

extension CategoryDetailViewController: AddNewWordOutput {
    func didCreateWord(with categoryId: String) {
        loadWords()
        delegate?.updateTotalCountWords(with: categoryId)
    }
}
