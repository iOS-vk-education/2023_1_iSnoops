//
//  CatalogCollectionViewDataSource.swift
//  easyLanguage
//
//  Created by Grigoriy on 26.10.2023.
//

import UIKit

extension TopFiveCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topFiveWordsCollectionView",
                                                            for: indexPath) as? TopFiveCollectionViewCell
        else {
            return .init()
        }

        inputTopFiveWords?.item(at: indexPath.item, completion: { topFiveWordsModel in
            cell.cellConfigure(with: topFiveWordsModel, at: indexPath)
        })

        return cell
    }
}
