//
//  CatalogCollectionViewDataSource.swift
//  easyLanguage
//
//  Created by Grigoriy on 26.10.2023.
//

import UIKit

extension TopFiveView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topFiveWordsCollectionView",
                                                            for: indexPath) as? TopFiveCollectionViewCell else {
            return .init()
        }
        cell.cellConfigure(with: topFiveModel[indexPath.item])
        return cell
    }
}

extension CategoriesView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoriesCollectionView",
                                                            for: indexPath) as? CategoryCollectionViewCell else {
            return .init()
        }
        cell.cellConfigure(with: categoriesModel[indexPath.item])
        return cell
    }
}
