//
//  CatalogCollectionViewDelegateFlowLayout.swift
//  easyLanguage
//
//  Created by Grigoriy on 26.10.2023.
//

import UIKit

extension TopFiveView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width / 3,
                      height: self.frame.width / 3)
    }
}

extension CategoriesCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width / 2 - 9,
                      height: self.frame.width / 2 - 9)
    }
}
