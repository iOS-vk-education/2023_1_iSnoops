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
                           completion: @escaping (Result<CategoryModel, Error>) -> Void) {
        Task {
            do {
                var categoryModel = CategoryModel(title: categoryName,
                                                  imageLink: nil,
                                                  studiedWordsCount: 0,
                                                  totalWordsCount: 0,
                                                  createdDate: Date(),
                                                  linkedWordsId: UUID().uuidString,
                                                  index: nil)

                let imageLink = try await addNewCategoryService.createNewCategory(with: categoryModel,
                                                                                  image: categoryImage)
                categoryModel.imageLink = imageLink
                completion(.success(categoryModel))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
