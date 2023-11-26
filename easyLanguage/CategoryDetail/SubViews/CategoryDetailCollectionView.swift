//
//  CategoryDetailCollectionView.swift
//  easyLanguage
//
//  Created by Grigoriy on 22.11.2023.
//

import UIKit

final class CategoryDetailCollectionView: UICollectionView {
    weak var inputWords: InputWordsDelegate?
    weak var changeLikeStatеDelegate: ChangeLikeStatеDelegate?

    init() {
        let layout = UICollectionViewFlowLayout()
        super.init(frame: .zero, collectionViewLayout: layout)
        backgroundColor = .PrimaryColors.Background.background
        setupCollectionView()
    }

    func categoryDetailCollectionViewReloadData() {
        self.reloadData()
    }

    func setupInputWordsDelegate(with inputWords: InputWordsDelegate?) {
        self.inputWords = inputWords
    }

    func setupChangeLikeStatеDelegate(with changeLikeStatеDelegate: ChangeLikeStatеDelegate?) {
        self.changeLikeStatеDelegate = changeLikeStatеDelegate
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
