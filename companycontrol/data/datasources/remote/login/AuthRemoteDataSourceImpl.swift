//
//  AuthRemoteDataSourceImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 12/05/2023.
//

import Foundation
import Firebase

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
    
    
    
}
