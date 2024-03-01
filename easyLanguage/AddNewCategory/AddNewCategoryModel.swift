//
//  AddNewCategoryModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 28.12.2023.
//

import UIKit

final class AddNewCategoryModel {

    private let service = AddNewCategoryService.shared

    func createNewCategory(with categoryName: String, image: UIImage?,
                           completion: @escaping (Result<CategoryModel, Error>) -> Void) {
        Task {
            do {
                var categoryModel = CategoryModel(title: categoryName)
                let imageLink = try await service.createNewCategory(with: categoryModel, image: image)
                categoryModel.imageLink = imageLink
                completion(.success(categoryModel))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
