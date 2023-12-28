//
//  AuthService.swift
//  easyLanguage
//
//  Created by Матвей Матюшко on 26.12.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthService {
    public static let shared = AuthService()

    public func registerUser(with userRequest: RegisterUserRequest,
                             completion: @escaping (Bool, Error?) -> Void) {
        let username = userRequest.username
        let email = userRequest.email
        let password = userRequest.password
        let userId = userRequest.userId

        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, error)
                print(error)
                return
            }
            guard let resultUser = result?.user else {
                completion(false, nil)
                return
            }

            let database = Firestore.firestore()
            database.collection("users")
                .document(resultUser.uid)
                .setData([
                    "username": username,
                    "email": email,
                    "userId": resultUser.uid
                ]) { error in
                    if let error = error {
                        completion(false, error)
                        return
                    }
                    completion(true, nil)
                }
        }
    }

    public func signIn(with userRequest: LoginUserRequest, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: userRequest.email, password: userRequest.password) { _, error in
            if let error = error {
                completion(error)
                return
            } else {
                completion(nil)
            }
        }
    }

    public func signOut(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
}
