//
//  CatalogViewController.swift
//  easyLanguage
//
//  Created by Grigoriy on 24.10.2023.
//  Главный экран, в котором прогресс и 2 коллекции: топ5 слов и категории.

import UIKit

protocol InputTopFiveWordsDelegate: AnyObject {
    var topFiveWordsCount: Int { get }
    func item(at index: Int, completion: @escaping (TopFiveWordsModel) -> Void)
}

protocol CategorieseOutputDelegate: AnyObject {
    func reloadHeight()
}

protocol ProgressSetup {
    func setProgressWords()
}

class CatalogViewController: CustomViewController {
    private let model = CatalogModel()
    private var topFiveModel: [TopFiveWordsModel] = [TopFiveWordsModel]()

    private let scrollView = UIScrollView()
    private let progressView = ProgressView()
    private lazy var topFiveView: TopFiveView = TopFiveView(inputTopFiveWords: self)
    private lazy var categoriesViewController = CategoriesViewController(categorieseOutputDelegate: self,
                                                                         navigationController: navigationController)

    private var categoriesViewHeightConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("wordsTitle", comment: "")

        setScrollView()

        [categoriesViewController.view, progressView, topFiveView].forEach {
            scrollView.addSubview($0)
        }
        addChild(categoriesViewController)

        setProgressView()
        setTopFiveView()

        setCategoriesView()
    }

    override func viewWillAppear(_ animated: Bool) {
        loadTopFiveWords()
        topFiveView.reloadData()
        setProgressWords()
    }
}

// MARK: - private methods
private extension CatalogViewController {
    func loadTopFiveWords() {
        model.loadTopFiveWords { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let data):
                self.topFiveModel = data
                self.topFiveView.reloadData()
            case .failure(let error):
                AlertManager.showDataLoadErrorAlert(on: self)
                print(error.localizedDescription)
            }
        }
    }

    func setScrollView() {
        view.addSubview(scrollView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    func setProgressView() {
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.topAnchor.constraint(equalTo: scrollView.topAnchor,
                                          constant: UIConstants.padding).isActive = true
        progressView.leftAnchor.constraint(equalTo: scrollView.leftAnchor,
                                           constant: UIConstants.padding).isActive = true
        progressView.rightAnchor.constraint(equalTo: scrollView.rightAnchor,
                                            constant: -UIConstants.padding).isActive = true
        progressView.widthAnchor.constraint(equalTo: scrollView.widthAnchor,
                                            constant: -UIConstants.padding * 2).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: view.bounds.height / 25).isActive = true
    }

    func setTopFiveView() {
        topFiveView.translatesAutoresizingMaskIntoConstraints = false
        topFiveView.topAnchor.constraint(equalTo: progressView.bottomAnchor,
                                         constant: UIConstants.padding).isActive = true
        topFiveView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        topFiveView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        topFiveView.heightAnchor.constraint(equalToConstant: view.frame.height / 4.5).isActive = true
    }

    func setCategoriesView() {
        categoriesViewController.view.translatesAutoresizingMaskIntoConstraints = false
        categoriesViewController.view.topAnchor.constraint(equalTo: topFiveView.bottomAnchor).isActive = true
        categoriesViewController.view.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        categoriesViewController.view.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        categoriesViewController.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true

        let categoriesHeightConstraint = CGFloat(35 + 10) // 35 - высота addIcon + её отсутуп до коллекции
        categoriesViewHeightConstraint = categoriesViewController.view.heightAnchor
            .constraint(equalToConstant: categoriesHeightConstraint)
        categoriesViewHeightConstraint?.isActive = true
        categoriesViewController.didMove(toParent: self)
    }
}
// MARK: - UIConstants
private extension CatalogViewController {
    struct UIConstants {
        static let padding: CGFloat = 18.0
    }
}

// MARK: - Protocol ProgressSetup
extension CatalogViewController: ProgressSetup {
    func setProgressWords() {
        model.loadProgressView { [weak self] result in
            switch result {
            case .success(let count):
                self?.progressView.setupAllLearnedWords(count: count.0)
                self?.progressView.setupWordsInProgress(count: count.1)
                self?.progressView.setProgress()
            case .failure(let error):
                print(error.localizedDescription)
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
            translations: topFiveModel[index].translations
        )
        completion(topFiveWordsModel)
    }
}

extension CatalogViewController: CategorieseOutputDelegate {
    func reloadHeight() {
        guard let heightConstraint = categoriesViewHeightConstraint else {
            AlertManager.showReloadHeightAlert(on: self)
            return
        }

        let newHeight = categoriesViewController.calculateCategoriesCollectionViewHeight()
        heightConstraint.constant = newHeight
        scrollView.layoutIfNeeded()
    }
}
