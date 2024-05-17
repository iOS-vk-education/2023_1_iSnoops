//
//  CategoriesCollectionViewDelegate.swift
//  easyLanguage
//
//  Created by Grigoriy on 13.12.2023.
//

import UIKit

extension CategoriesCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        inputCategories?.categoriesCount ?? 0
    }
}
