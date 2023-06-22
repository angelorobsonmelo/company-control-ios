//
//  GetCompaniesUseCaseImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 07/06/2023.
//

import Foundation
import Combine

class GetCompaniesUseCaseImpl: GetCompaniesUseCase {
    
    
    let repository: CompanyRepository
    
    init(repository: CompanyRepository) {
        self.repository = repository
    }
    
    func execute(userEmail: String) -> AnyPublisher<[CompanyResponse], Error> {
        return repository.getAll(userEmail: userEmail)
    }
    
    
}
