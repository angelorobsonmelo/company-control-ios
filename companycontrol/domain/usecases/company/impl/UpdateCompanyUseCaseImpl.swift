//
//  UpdateCompanyUseCaseImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 07/06/2023.
//

import Foundation

class UpdateCompanyUseCaseImpl: UpdateCompanyUseCase {
    
    let repository: CompanyRepository
    
    init(repository: CompanyRepository) {
        self.repository = repository
    }
    
    func update(request: CompanyRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        guard !request.name.isEmpty else {
            completion(.failure(ValidationFormEnum.emptyField(reason: "Name can not be empty")))
            return
        }
        
        guard !request.address.isEmpty else {
            completion(.failure(ValidationFormEnum.emptyField(reason: "Address can not be empty")))
            return
        }
        
        guard !request.contactNumber.isEmpty else {
            completion(.failure(ValidationFormEnum.emptyField(reason: "Contact number can not be empty")))
            return
        }
        
        repository.update(request: request, completion: completion)
    }
    
    
    
}
