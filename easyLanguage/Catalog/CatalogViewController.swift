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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("wordsTitle", comment: "")
        
        view.addSubview(scrollView)
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
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    func setProgressView() {
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.topAnchor.constraint(equalTo: scrollView.topAnchor,
                                          constant: UIConstants.ProgressView.padding).isActive = true
        progressView.leftAnchor.constraint(equalTo: scrollView.leftAnchor,
                                           constant: UIConstants.ProgressView.padding).isActive = true
        progressView.rightAnchor.constraint(equalTo: scrollView.rightAnchor,
                                            constant: -UIConstants.ProgressView.padding).isActive = true
        progressView.widthAnchor.constraint(equalTo: scrollView.widthAnchor,
                                            constant: -UIConstants.ProgressView.padding * 2).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: view.bounds.height / 25).isActive = true
    }

    func setTopFiveView() {
        topFiveView.translatesAutoresizingMaskIntoConstraints = false
        topFiveView.topAnchor.constraint(equalTo: progressView.bottomAnchor,
                                         constant: UIConstants.TopFiveView.top).isActive = true
        topFiveView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        topFiveView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        topFiveView.heightAnchor.constraint(equalToConstant: view.frame.height / 4.5).isActive = true
    }

    func setCategoriesView() {
        categoriesViewController.view.translatesAutoresizingMaskIntoConstraints = false
        categoriesViewController.view.topAnchor.constraint(equalTo: topFiveView.bottomAnchor,
                                            constant: UIConstants.CategoriesView.top).isActive = true
        categoriesViewController.view.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        categoriesViewController.view.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        categoriesViewController.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        categoriesViewController.didMove(toParent: self)
    }
}
// MARK: - UIConstants
// swiftlint:disable nesting
private extension CatalogViewController {
    struct UIConstants {
        struct ProgressView {
            static let padding: CGFloat = 18.0
        }

        struct TopFiveView {
            static let top: CGFloat = 12.0
            static let left: CGFloat = 18.0
        }

        struct CategoriesView {
            static let top: CGFloat = 12.0
        }
    }
}
// swiftlint:enable nesting

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
        print(categoriesViewController.calculateCategoriesCollectionViewHeight())
        categoriesViewController.view.heightAnchor.constraint(equalToConstant:
                                 categoriesViewController.calculateCategoriesCollectionViewHeight()).isActive = true
    }
}
