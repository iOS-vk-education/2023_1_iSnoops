//
//  CategoryDetailCollectionViewDataSource.swift
//  easyLanguage
//
//  Created by Grigoriy on 10.12.2023.
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

        let index = inputWords?.index ?? 0
        inputWords?.item(at: indexPath.item, completion: { wordUIModel in
            cell.cellConfigure(with: index, cellIndex: indexPath.item, wordUIModel: wordUIModel)
        })

        if let inputWords = inputWords {
            cell.setInputWords(with: inputWords)
        }

        return cell
    }
}
