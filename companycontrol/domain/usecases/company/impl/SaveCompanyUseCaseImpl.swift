//
//  SaveCompanyUseCaseImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 07/06/2023.
//

import Foundation

class SaveCompanyUseCaseImpl: SaveCompanyUseCase {
    
    let repository: CompanyRepository
    
    init(repository: CompanyRepository) {
        self.repository = repository
    }
    
    func save(request: CompanyRequest, completion: @escaping (Result<Void, Error>) -> Void) {
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
        
        
        repository.save(request: request, completion: completion)
    }
    
    
    
}
