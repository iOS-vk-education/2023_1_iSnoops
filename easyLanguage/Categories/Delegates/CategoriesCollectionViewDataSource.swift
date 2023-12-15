//
//  CategoriesCollectionViewDataSource.swift
//  easyLanguage
//
//  Created by Grigoriy on 13.12.2023.
//

import UIKit

extension CategoriesCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoriesCollectionView",
                                                            for: indexPath) as? CategoryCollectionViewCell
        else {
            return .init()
        }

        inputCategories?.item(at: indexPath.item) { categoryUIModel in
            cell.cellConfigure(with: categoryUIModel, at: indexPath)
        }

        return cell
    }
}
