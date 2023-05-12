//
//  RegisterUseCaseImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 12/05/2023.
//

import Foundation

class RegisterUseCaseImpl: RegisterUseCase {
    
    private let remoteDataSource: AuthRemoteDataSource
    
    init(remoteDataSource: AuthRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    func register(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let emailLowercased = email.lowercased()
        
        remoteDataSource.register(email: emailLowercased, password: password, completion: completion)
    }
    
    
    
}
