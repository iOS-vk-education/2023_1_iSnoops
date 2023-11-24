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

        cell.setCategoryID(with: 0)

        return cell
    }
}
