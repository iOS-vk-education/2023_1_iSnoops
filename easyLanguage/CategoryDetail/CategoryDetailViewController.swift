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
    func changeIsLearned(with number: Int, isLearned: Bool, swipesCounter: Int)
    func showActionSheet(with id: String)
    func showAlert(with title: String)
}

protocol CategoryDetailOutput: AnyObject {
    func updateCountWords(with parameters: UpdateCountWordsParameters)
}

final class CategoryDetailViewController: CustomViewController {
    private let noWordsLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("emptyCategoryAdvice", comment: "")
        label.textColor = .PrimaryColors.Font.secondary
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    private let loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.hidesWhenStopped = true
        return loader
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
    private var selectedCategory = 0
    private var linkedWordsId = ""
    weak var delegate: CategoryDetailOutput?

    private let model = CategoryDetailModel()
    private let coreData = CoreDataService()

    lazy var height = { view.bounds.height / 15 }()

    override func viewDidLoad() {
        super.viewDidLoad()

        [collectionView, noWordsLabel, loader, button].forEach {
            view.addSubview($0)
        }

        setContentInset()
//        loadWords()
        loadFromCoreData()
        setNavBar()
        setNoWordsLabel()
        setLoader()
        setCollectionView()
        setButton()

        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
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

    @objc
    func didTapButton() {
        let learningVC = LearningViewController(isNeedLoadAll: false, categoryId: linkedWordsId, loadOneCategory: true)
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

// MARK: - CoreData

private extension CategoryDetailViewController {
    func loadFromCoreData() {
        loader.startAnimating()

        wordsModel = model.loadCDWords(with: linkedWordsId)

        loader.stopAnimating()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

// MARK: - networking

private extension CategoryDetailViewController {
    func loadWords() {
        loader.startAnimating()
        model.loadWords(with: linkedWordsId) { [weak self] result in
            guard let self = self else {
                return
            }

            loader.stopAnimating()

            switch result {
            case .success(let data):
                self.wordsModel = data
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                noWordsLabel.isHidden = !wordsModel.isEmpty
            case .failure(let error):
                AlertManager.showDataLoadErrorAlert(on: self)
                print("[DEBUG]: \(#function), \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - private methods
private extension CategoryDetailViewController {
    func setContentInset() {
        collectionView.setContentInset(with: height + UIConstants.height * 2)
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

    func setLoader() {
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loader.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
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
        static let height: CGFloat = 5.0
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
                                    swipesCounter: wordsModel[index].swipesCounter,
                                    id: wordsModel[index].id)
        completion(wordModel)
    }

    func changeIsLearned(with number: Int, isLearned: Bool, swipesCounter: Int) {
//        model.reloadIsLearned(with: wordsModel[number].id, isLearned: isLearned, swipesCounter: swipesCounter)
        model.reloadCDIsLearned(with: wordsModel[number].id, isLearned: isLearned, swipesCounter: swipesCounter)
        self.delegate?.updateCountWords(with: UpdateCountWordsParameters(linkedWordsId: wordsModel[number].categoryId,
                                                                         changeTotalCount: false,
                                                                         changeLearnedCount: true,
                                                                         isLearned: isLearned,
                                                                         isDeleted: false))
    }

    func showActionSheet(with id: String) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        addActionToDeleteWord(with: id, to: alertController)
        addActionToCancel(to: alertController)

        present(alertController, animated: true, completion: nil)
    }

    func showAlert(with title: String) {
        AlertManager.showWordDeleteAlert(on: self)
    }

    private func addActionToDeleteWord(with id: String, to alertController: UIAlertController) {
        let deleteAction = UIAlertAction(title: NSLocalizedString("detailDelete", comment: ""),
                                         style: .destructive) { _ in
//            self.handleDeleteWord(with: id)
            self.handleDeleteCDWord(with: id)
        }

        alertController.addAction(deleteAction)
    }

    private func handleDeleteCDWord(with id: String) {
        model.deleteCDWord(with: id) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success:
                self.handleSuccessfulDeletion(with: id)
            case .failure(let error):
                AlertManager.showWordDeleteAlert(on: self)
                print(error.localizedDescription)
            }
        }
    }

    private func handleDeleteWord(with id: String) {
        model.deleteWord(with: id) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success:
                self.handleSuccessfulDeletion(with: id)
            case .failure(let error):
                AlertManager.showWordDeleteAlert(on: self)
                print(error.localizedDescription)
            }
        }
    }

    private func handleSuccessfulDeletion(with id: String) {
        guard let index = wordsModel.firstIndex(where: { $0.id == id }) else {
            print("Word not found :(")
            return
        }

        let categoryId = wordsModel[index].categoryId
        let isLearned = wordsModel[index].isLearned

        DispatchQueue.main.async {
            self.delegate?.updateCountWords(with: UpdateCountWordsParameters(
                linkedWordsId: categoryId,
                changeTotalCount: true,
                changeLearnedCount: isLearned,
                isLearned: false,
                isDeleted: true
            ))

            self.wordsModel.removeAll(where: { $0.id == id })
            self.collectionView.reloadData()
        }
    }

    private func addActionToCancel(to alertController: UIAlertController) {
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel) { _ in }
        alertController.addAction(cancelAction)
    }
}

extension CategoryDetailViewController: AddWordOutput {
    func isWordExist(with uiModel: WordUIModel) -> Bool {
        wordsModel.contains { word in
            word.translations["ru"]?.lowercased() == uiModel.translations["ru"] ?? "".lowercased() &&
            word.translations["en"]?.lowercased() == uiModel.translations["en"] ?? "".lowercased()
        }
    }

    func didCreateWord(with categoryId: String) {
//        loadWords()
        loadFromCoreData()
        delegate?.updateCountWords(with: UpdateCountWordsParameters(linkedWordsId: categoryId,
                                                                         changeTotalCount: true,
                                                                         changeLearnedCount: false,
                                                                         isLearned: false,
                                                                         isDeleted: false))
    }
}
