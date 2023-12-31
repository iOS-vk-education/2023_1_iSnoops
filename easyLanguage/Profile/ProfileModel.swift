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

    func loadProfile(completion: @escaping (Result<RegisterUserRequest, Error>) -> Void) {

        profileService.loadProfile(completion: completion)
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
