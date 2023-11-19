//
//  TopFiveCollectionView.swift
//  easyLanguage
//
//  Created by Grigoriy on 18.11.2023.
//

import UIKit

final class TopFiveCollectionView: UICollectionView {
    weak var inputTopFiveWords: InputTopFiveWords?

    init() {
        let layout = UICollectionViewFlowLayout()
        super.init(frame: .zero, collectionViewLayout: layout)

        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCollectionView()
    }

    func setupInputTopFiveWords(with inputTopFiveWords: InputTopFiveWords?) {
        self.inputTopFiveWords = inputTopFiveWords
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        self.collectionViewLayout = layout
        showsHorizontalScrollIndicator = false
        backgroundColor = .PrimaryColors.Background.background

        delegate = self
        dataSource = self

        register(TopFiveCollectionViewCell.self, forCellWithReuseIdentifier: "topFiveWordsCollectionView")
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumLineSpacing = UIScreen.main.bounds.width / 21.8
        }
    }
}
