//
//  CatalogCollectionViewDataSource.swift
//  easyLanguage
//
//  Created by Grigoriy on 26.10.2023.
//

import UIKit

extension TopFiveCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topFiveWordsCollectionView",
                                                            for: indexPath) as? TopFiveCollectionViewCell
        else {
            return .init()
        }

        inputTopFiveWords?.item(at: indexPath.item, completion: { topFiveWordsModel in
            cell.cellConfigure(with: topFiveWordsModel, at: indexPath)
        })

        return cell
    }
}

extension CategoriesCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoriesCollectionView",
                                                            for: indexPath) as? CategoryCollectionViewCell
        else {
            return .init()
        }
        inputCategories?.item(at: indexPath.item) { categoryUIModel in
            cell.cellConfigure(with: categoryUIModel, at: indexPath.item)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let categoryDetailViewController = CategoryDetailViewController()
        categoryDetailViewController.selectedItem = indexPath.item
        categoryDetailViewController.updateCountWordsDelegate = self.updateCountWordsDelegate
        categoryDetailViewController.categoryDetailTitle = inputCategories?.getTitle(at: indexPath.item) ?? ""
        categoryDetailViewController.linkedWordsId = inputCategories?.getLinkedWordsId(at: indexPath.item) ?? ""
        navigationController?.pushViewController(categoryDetailViewController, animated: true)
    }
}
