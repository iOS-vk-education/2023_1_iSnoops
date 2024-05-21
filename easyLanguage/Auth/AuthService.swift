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
    private let coreData = CoreDataService()

    public func registerUser(with userRequest: RegisterUserRequest,
                             completion: @escaping (Bool, Error?) -> Void) {
        let username = userRequest.username
        let email = userRequest.email
        let password = userRequest.password
        let time = userRequest.time

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
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
                    "userId": resultUser.uid,
                    "time": time
                ]) { error in
                    if let error = error {
                        completion(false, error)
                        return
                    }
                    self?.coreData.saveProfile(username: username, email: email, userId: resultUser.uid, time: time)
                    completion(true, nil)
                }
        }
    }

    // TODO: - проверить авторизация
    public func signIn(with userRequest: LoginUserRequest, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: userRequest.email, password: userRequest.password) { [weak self] result, error in
            if let error = error {
                completion(error)
                return
            }

            guard let self = self, let userId = Auth.auth().currentUser?.uid else {
                completion(NetworkError.unexpected)
                return
            }

            let database = Firestore.firestore()
            database.collection("users").document(userId).getDocument { document, error in
                if let error = error {
                    completion(error)
                    return
                }
                guard let document = document, document.exists,
                      let data = document.data(),
                      let username = data["username"] as? String,
                      let email = data["email"] as? String,
                      let timestamp = data["time"] as? Timestamp else {
                    completion(NetworkError.emptyData)
                    return
                }
                let time = timestamp.dateValue()
                self.coreData.saveProfile(username: username, email: email, userId: userId, time: time)
                completion(nil)
            }
        }
    }

    // TODO: - проверить выход
    public func signOut(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
}
