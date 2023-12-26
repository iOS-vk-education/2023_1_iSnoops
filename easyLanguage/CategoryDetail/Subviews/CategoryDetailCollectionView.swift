//
//  CategoryDetailCollectionView.swift
//  easyLanguage
//
//  Created by Grigoriy on 10.12.2023.
//

import UIKit

final class CategoryDetailCollectionView: UICollectionView {
    weak var inputWords: InputWordsDelegate?

    init(inputWords: InputWordsDelegate?) {
        self.inputWords = inputWords

        let layout = UICollectionViewFlowLayout()
        super.init(frame: .zero, collectionViewLayout: layout)
        backgroundColor = .PrimaryColors.Background.background
        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCollectionView()
    }

    private func setupCollectionView() {
        delegate = self
        dataSource = self
        register(CategoryDetailCollectionViewCell.self, forCellWithReuseIdentifier: "CategoryDetailCollectionView")
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumLineSpacing = 18
        }
    }
}
