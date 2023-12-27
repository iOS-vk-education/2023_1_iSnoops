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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedCategory = inputCategories?.getCatalogModel(with: indexPath.item) {
            let categoryDetailViewController = CategoryDetailViewController()
            categoryDetailViewController.set(with: selectedCategory)
            navigationController?.pushViewController(categoryDetailViewController, animated: true)
        }
    }
}
