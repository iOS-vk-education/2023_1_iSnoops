//
//  ProfileModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 27.12.2023.
//

import UIKit

final class ProfileModel {
    let profileService = ProfileService.shared

    private let imageManager = ImageManager.shared

    func loadProfile(completion: @escaping (Result<ProfileApiModel, Error>) -> Void) {
        profileService.loadProfile(completion: completion)
    }
}
