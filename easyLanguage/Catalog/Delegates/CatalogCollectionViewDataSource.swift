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
extension CategoriesCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoriesCollectionView",
                                                            for: indexPath) as? CategoryCollectionViewCell else {
            return .init()
        }
        let uimodel: CategoryUIModel = (inputCategories?.item(at: indexPath.item)) ?? CategoryUIModel()
        cell.cellConfigure(with: uimodel)
        return cell
    }
}
