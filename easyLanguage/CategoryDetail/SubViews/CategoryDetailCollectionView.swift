//
//  CategoryDetailCollectionView.swift
//  easyLanguage
//
//  Created by Grigoriy on 22.11.2023.
//

import UIKit

final class CategoryDetailCollectionView: UICollectionView {
    weak var inputWords: InputWordsDelegate?

    init() {
        let layout = UICollectionViewFlowLayout()
        super.init(frame: .zero, collectionViewLayout: layout)
        backgroundColor = .PrimaryColors.Background.background
        setupCollectionView()
    }

    func setupInputWordsDelegate(with inputWords: InputWordsDelegate?) {
        self.inputWords = inputWords
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
            flowLayout.minimumLineSpacing = UIScreen.main.bounds.width / 20.5
        }
    }
}
