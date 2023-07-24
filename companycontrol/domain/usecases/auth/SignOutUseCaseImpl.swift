//
//  SignOutUseCaseImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 24/07/2023.
//

import Foundation
import Combine

class SignOutUseCaseImpl: SignOutUseCase {
    
    let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<Void, Error> {
        return repository.signOut()
    }
    
    
    
}
