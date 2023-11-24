//
//  CategoryDetailViewDelegateFlowLayout.swift
//  easyLanguage
//
//  Created by Grigoriy on 22.11.2023.
//

import UIKit

extension CategoryDetailCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width / 2 - 9,
                      height: self.frame.width / 2 - 9)
    }
}
