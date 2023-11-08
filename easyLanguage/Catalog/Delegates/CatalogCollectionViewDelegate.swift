//
//  CatalogCollectionViewDelegate.swift
//  easyLanguage
//
//  Created by Grigoriy on 26.10.2023.
//

import UIKit

extension TopFiveView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        topFiveModel.count
    }
}

extension CategoriesCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inputCategories?.categoriesCount ?? 0
    }
}
