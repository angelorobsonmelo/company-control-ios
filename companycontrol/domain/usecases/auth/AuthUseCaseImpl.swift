//
//  AuthUseCaseImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 12/05/2023.
//

import Foundation

class AuthUseCaseImpl: AuthUseCase {
    
    private let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func auth(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        repository.auth(email: email, password: password, completion: completion)
    }
    
    
}
