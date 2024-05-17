//
//  AddNewCategoryModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 28.12.2023.
//

import UIKit
import CoreData

final class AddNewCategoryModel {

    private let service = AddNewCategoryService.shared
    private let coreData = CoreDataService()

    func createNewCategory(with categoryName: String, image: UIImage?,
                           completion: @escaping (Result<CategoryModel, Error>) -> Void) {
        Task {
            do {
                var categoryModel = CategoryModel(title: categoryName)
                let imageData = imageToData(image: ((image ?? .defaultImage)))
                categoryModel.imageData = imageData
                coreData.saveCategory(with: categoryModel, imageData: imageData)

//                let imageLink = try await service.createNewCategory(with: categoryModel, image: image)
//                categoryModel.imageLink = imageLink

                completion(.success(categoryModel))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func imageToData(image: UIImage) -> Data? {
        guard let imageData = image.jpegData(compressionQuality: 0.2) else {
            return nil
        }
        return imageData
    }
}

private extension UIImage {
    static let defaultImage = UIImage(systemName: "questionmark")!
}
