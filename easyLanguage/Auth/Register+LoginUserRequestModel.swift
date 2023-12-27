//
//  RegisterUserRequest.swift.swift
//  easyLanguage
//
//  Created by Матвей Матюшко on 26.12.2023.
//

import Foundation

struct RegisterUserRequest {
    let username: String
    let email: String
    let password: String
}

struct LoginUserRequest {
    let email: String
    let password: String
}