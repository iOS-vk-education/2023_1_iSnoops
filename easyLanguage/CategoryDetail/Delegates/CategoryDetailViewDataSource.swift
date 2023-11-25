//
//  CategoryDetailViewDataSource.swift
//  easyLanguage
//
//  Created by Grigoriy on 22.11.2023.
//

import UIKit

extension CategoryDetailCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryDetailCollectionView",
                                                            for: indexPath) as? CategoryDetailCollectionViewCell
        else {
            return .init()
        }
        let selectedCategory = inputWords?.selectedCategory ?? 0
        inputWords?.item(at: indexPath.item, completion: { wordModel in
            cell.cellConfigure(with: selectedCategory,
                               wordModel: wordModel)
        })

        return cell
    }
}
