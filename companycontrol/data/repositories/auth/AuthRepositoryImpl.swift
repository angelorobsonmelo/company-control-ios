//
//  AuthRepositoryImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 12/05/2023.
//

import Foundation

class AuthRepositoryImpl: AuthRepository {
    
    private let remoteDataSource: AuthRemoteDataSource
    
    init(remoteDataSource: AuthRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    func auth(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        self.remoteDataSource.auth(email: email, password: password, completion: completion)
    }
    
    
}
