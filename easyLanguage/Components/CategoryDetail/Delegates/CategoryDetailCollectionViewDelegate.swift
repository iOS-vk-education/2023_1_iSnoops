//
//  CategoryDetailCollectionViewDelegate.swift
//  easyLanguage
//
//  Created by Grigoriy on 10.12.2023.
//

import UIKit

extension CategoryDetailCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        inputWords?.wordsCount ?? 0
    }
}
