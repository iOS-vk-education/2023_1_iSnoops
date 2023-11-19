//
//  CategoriesCollectionView.swift
//  easyLanguage
//
//  Created by Grigoriy on 07.11.2023.
//

import UIKit

final class CategoriesCollectionView: UICollectionView {
    weak var inputCategories: InputCategories?

    init() {
        let layout = UICollectionViewFlowLayout()
        super.init(frame: .zero, collectionViewLayout: layout)

        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCollectionView()
    }

    func setupInputCategories(with inputCategories: InputCategories?) {
        self.inputCategories = inputCategories
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
