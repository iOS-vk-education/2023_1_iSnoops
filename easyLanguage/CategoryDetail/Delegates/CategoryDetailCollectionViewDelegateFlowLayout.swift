//
//  CategoryDetailCollectionViewDelegateFlowLayout.swift
//  easyLanguage
//
//  Created by Grigoriy on 10.12.2023.
//

import UIKit

extension CategoryDetailCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width / 2 - 18,
                      height: self.frame.width / 2 - 9)
    }
}
