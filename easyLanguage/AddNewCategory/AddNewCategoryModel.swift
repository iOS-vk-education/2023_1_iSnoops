//
//  AddNewCategoryModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 28.12.2023.
//

import UIKit

final class AddNewCategoryModel {

    private let addNewCategoryService = AddNewCategoryService.shared

    func createNewCategory(with categoryName: String, categoryImage: UIImage?,
                           completion: @escaping (Result<CategoryUIModel, Error>) -> Void) {
        Task {
            do {
                let categoryUIModel = CategoryUIModel(title: categoryName,
                                                      image: categoryImage,
                                                      studiedWordsCount: 0,
                                                      totalWordsCount: 0,
                                                      linkedWordsId: UUID().uuidString)

                try await addNewCategoryService.createNewCategory(with: categoryUIModel)
                completion(.success(categoryUIModel))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
