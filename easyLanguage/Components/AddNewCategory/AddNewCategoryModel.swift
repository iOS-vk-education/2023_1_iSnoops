//
//  AddNewCategoryModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 28.12.2023.
//

import UIKit

final class AddNewCategoryModel {

    private let service = AddNewCategoryService.shared

    private let coreData = CoreDataService()

    func createNewCategory(with categoryName: String, image: UIImage?,
                           completion: @escaping (Result<CategoryModel, Error>) -> Void) {
        Task {
            do {
                var categoryModel = CategoryModel(title: categoryName)
                let imageLink = try await service.createNewCategory(with: categoryModel, image: image)
                categoryModel.imageLink = imageLink
                coreData.saveCategory(with: categoryModel)
                completion(.success(categoryModel))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func mapTo() {
        
    }
}
