//
//  CatalogViewController.swift
//  easyLanguage
//
//  Created by Grigoriy on 24.10.2023.
//

import UIKit

class CatalogViewController: CustomViewController {

    private let scrollView = UIScrollView()
    private let progressView = ProgressView()
    private let topFiveView = TopFiveView()
    private let categoriesView: CategoriesView = CategoriesView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        [progressView, topFiveView, categoriesView].forEach {
            scrollView.addSubview($0)
        }

        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 18).isActive = true
        progressView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 18).isActive = true
        progressView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -18).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        progressView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -36).isActive = true

        topFiveView.translatesAutoresizingMaskIntoConstraints = false
        topFiveView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 18).isActive = true
        topFiveView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 18).isActive = true
        topFiveView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        topFiveView.heightAnchor.constraint(equalToConstant: 189).isActive = true

        categoriesView.translatesAutoresizingMaskIntoConstraints = false
        categoriesView.topAnchor.constraint(equalTo: topFiveView.bottomAnchor, constant: 18).isActive = true
        categoriesView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        categoriesView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        categoriesView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true

        let constant: CGFloat = topFiveView.frame.maxY + 18
        + CGFloat((view.frame.width / 2 - 27 + 19) * CGFloat(categoriesView.countEvenCells()) + 45)
        categoriesView.heightAnchor.constraint(equalToConstant: constant).isActive = true

        setup()
    }
}

// MARK: - private methods
private extension CatalogViewController {
    func setup() {
        title = "Слова"
        progressView.setupCountOfWords(with: 120) // должна с бека сумма всех слов приходить
    }
}
