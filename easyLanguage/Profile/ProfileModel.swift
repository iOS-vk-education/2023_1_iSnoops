//
//  ProfileModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 27.12.2023.
//

import UIKit

final class ProfileModel {
    let profileService = ProfileService.shared
    private let categoryService = CategoryService.shared

    private let imageManager = ImageManager.shared

    func loadProfile() async throws -> ProfileApiModel {
        try await profileService.loadProfile()
    }

    func uploadImage(image: UIImage) async throws -> URL {
        try await profileService.uploadImage(image: image)
    }

    func loadProgressView(completion: @escaping (Result<(Int, Int), Error>) -> Void) {
        Task {
            do {
                let counts = try await self.categoryService.loadProgressView()
                await MainActor.run {
                    completion(.success(counts))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
}
