//
//  CategoriesCollectionViewDelegateFlowLayout.swift
//  easyLanguage
//
//  Created by Grigoriy on 13.12.2023.
//

import UIKit

extension CategoriesCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 2 - 9, // 18 - minimumLineSpacing
                      height: frame.width / 2 - 9)
    }
}
