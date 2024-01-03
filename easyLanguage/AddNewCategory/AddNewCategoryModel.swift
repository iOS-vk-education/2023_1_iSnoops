//
//  AddNewCategoryModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 28.12.2023.
//

import UIKit

final class AddNewCategoryModel {

    private let addNewCategoryService = AddNewCategoryService.shared
    // swiftlint:disable line_length
    private let defaultImageLink = "https://firebasestorage.googleapis.com/v0/b/easylanguage-e6d17.appspot.com/o/categories%2F1E1922CE-61D4-46BE-B2C7-4E12B316CCFA?alt=media&token=80174f66-ee40-4f34-9a35-8d7ed4fbd571"
    // swiftlint:enable line_length

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
                categoryModel.imageLink = imageLink ?? defaultImageLink
                completion(.success(categoryModel))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
