//
//  DeleteCompanyUseCaseImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 07/06/2023.
//

import Foundation
import Combine

class DeleteCompanyUseCaseImpl: DeleteCompanyUseCase {
    
    let repository: CompanyRepository
    
    init(repository: CompanyRepository) {
        self.repository = repository
    }
    
    func execute(id: String) -> AnyPublisher<Void, Error> {
       return repository.delete(id: id)
    }
    
    
    
}
