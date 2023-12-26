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

class CatalogViewController: CustomViewController {
    private let output: CatalogViewOutput
    private var topFiveModel: [TopFiveWordsModel] = [TopFiveWordsModel]()

    private let scrollView = UIScrollView()
    private let progressView = ProgressView()
    private lazy var topFiveView: TopFiveView = TopFiveView(inputTopFiveWords: self)
    private lazy var categoriesViewController = CategoriesViewController()

    init(output: CatalogViewOutput) {
        self.output = output

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        output.didLoadView()
    }
}

// MARK: - private methods
private extension CatalogViewController {
    func setup() {
        title = "Слова"
        view.addSubview(scrollView)
        setScrollView()

        [categoriesViewController.view, progressView, topFiveView].forEach {
            scrollView.addSubview($0)
        }
        addChild(categoriesViewController)

        setProgressView()
        setTopFiveView()
        setCategoriesView()
//        setupAllLearnedWords()
//        setupWordsInProgress()
//        setProgress()
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
        progressView.heightAnchor.constraint(equalToConstant: view.frame.height / 12).isActive = true
    }

    func setTopFiveView() {
        topFiveView.translatesAutoresizingMaskIntoConstraints = false
        topFiveView.topAnchor.constraint(equalTo: progressView.bottomAnchor,
                                         constant: UIConstants.TopFiveView.top).isActive = true
        topFiveView.leftAnchor.constraint(equalTo: scrollView.leftAnchor,
                                          constant: UIConstants.TopFiveView.left).isActive = true
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
        categoriesViewController.view.heightAnchor.constraint(equalToConstant:
                                 categoriesViewController.calculateCategoriesCollectionViewHeight()).isActive = true
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

// MARK: - Protocol InputTopFiveWordsDelegate
extension CatalogViewController: InputTopFiveWordsDelegate {
    var topFiveWordsCount: Int {
        topFiveModel.count
    }

    func item(at index: Int, completion: @escaping (TopFiveWordsModel) -> Void) {
        let topFiveWordsModel = TopFiveWordsModel(
            translations: topFiveModel[index].translations,
            level: topFiveModel[index].level
        )
        completion(topFiveWordsModel)
    }
}

extension CatalogViewController: CatalogViewInput {
    func configureTopFiveWords(with data: [TopFiveWordsModel]) {
        self.topFiveModel = data
    }

    func setProgress() {
        progressView.setProgress()
    }

    func setupAllLearnedWords(with count: Int) {
        progressView.setupAllLearnedWords(count: count)
    }

    func setupWordsInProgress(with count: Int) {
        progressView.setupWordsInProgress(count: count)
    }

    func showError(with text: String) {
        print(text) //FIXME: - заменить либо на алерт либо на либу с алертами
    }
}
