//
//  RegisterUserRequest.swift.swift
//  easyLanguage
//
//  Created by Матвей Матюшко on 26.12.2023.
//

import Foundation

struct RegisterUserRequest: Decodable {
    let username: String
    let email: String
    let password: String
    let userId: String
}

struct LoginUserRequest {
    let email: String
    let password: String
}
