//
//  DeleteCompanyUseCaseImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 07/06/2023.
//

import Foundation

class DeleteCompanyUseCaseImpl: DeleteCompanyUseCase {
    
    let repository: CompanyRepository
    
    init(repository: CompanyRepository) {
        self.repository = repository
    }
    
    func delete(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        repository.delete(id: id, completion: completion)
    }
    
    
    
}
