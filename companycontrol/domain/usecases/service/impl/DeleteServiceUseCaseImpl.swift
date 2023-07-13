//
//  DeleteServiceUseCaseImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 13/07/2023.
//

import Foundation
import Combine

class DeleteServiceUseCaseImpl: DeleteServiceUseCase {
    
    let repository: ServiceRepository
    
    init(repository: ServiceRepository) {
        self.repository = repository
    }
    
    func execute(id: String) -> AnyPublisher<Void, Error> {
       return repository.delete(id: id)
    }
    
    
    
}
