//
//  CategoriesCollectionView.swift
//  easyLanguage
//
//  Created by Grigoriy on 07.11.2023.
//

import UIKit

final class CategoriesCollectionView: UICollectionView {
    weak var inputCategories: InputCategoriesDelegate?
    weak var updateCountWordsDelegate: UpdateCountWordsDelegate?
    weak var navigationController: UINavigationController?

    init() {
        let layout = UICollectionViewFlowLayout()
        super.init(frame: .zero, collectionViewLayout: layout)

        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCollectionView()
    }

    func setupUpdateCountWordsDelegate(with updateCountWordsDelegate: UpdateCountWordsDelegate?) {
        self.updateCountWordsDelegate = updateCountWordsDelegate
    }

    func setupInputCategoriesDelegate(with inputCategories: InputCategoriesDelegate?) {
        self.inputCategories = inputCategories
    }

    func setupNavigationController(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    private func setupCollectionView() {
        isScrollEnabled = false
        showsVerticalScrollIndicator = false
        backgroundColor = .PrimaryColors.Background.background

        delegate = self
        dataSource = self

        register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "categoriesCollectionView")
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumLineSpacing = UIScreen.main.bounds.width / 20.5
        }
    }
}
