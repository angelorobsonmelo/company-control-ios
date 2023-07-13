//
//  GetAllServicesUseCaseImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 13/07/2023.
//

import Foundation
import Combine

class GetAllServicesUseCaseImpl: GetAllServiceUseCase {
    
    let repository: ServiceRepository
    
    init(repository: ServiceRepository) {
        self.repository = repository
    }
    
    func execute(userEmail: String, startDate: Date, endDate: Date) -> AnyPublisher<[ServiceResponse], Error> {
        return repository.getAll(userEmail: userEmail, startDate: startDate, endDate: endDate)
    }
    

}
