//
//  CategoryDetailViewDelegate.swift
//  easyLanguage
//
//  Created by Grigoriy on 22.11.2023.
//

import UIKit

extension CategoryDetailCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        inputWords?.wordsCount ?? 0
    }
}
