//
//  CatalogCollectionViewDelegate.swift
//  easyLanguage
//
//  Created by Grigoriy on 26.10.2023.
//

import UIKit

extension TopFiveCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        inputTopFiveWords?.topFiveWordsCount ?? 0
    }
}
