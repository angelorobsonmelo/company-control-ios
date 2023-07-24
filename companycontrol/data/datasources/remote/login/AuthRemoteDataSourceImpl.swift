//
//  AuthRemoteDataSourceImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 12/05/2023.
//

import Foundation
import Firebase
import Combine

class AuthRemoteDataSourceImpl: AuthRemoteDataSource {
    
    private let auth: Auth
    
    init(auth: Auth) {
        self.auth = auth
    }
    
    
    func auth(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        self.auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func register(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        self.auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    
    func signOut() -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            do {
                try self.auth.signOut()
                promise(.success(()))
            } catch let signOutError {
                promise(.failure(signOutError))
            }
        }.eraseToAnyPublisher()
    }
    
    
    
}
