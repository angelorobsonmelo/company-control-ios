//
//  GetBalanceUseCaseImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 20/07/2023.
//

import Foundation
import Combine

class GetBalanceUseCaseImpl: GetBalanceUseCase {
    
    
    let serviceRepository: ServiceRepository
    let expenseRepository: ExpenseRepository
    
    init(
        serviceRepository: ServiceRepository,
        expenseRepository: ExpenseRepository
    ) {
        self.serviceRepository = serviceRepository
        self.expenseRepository = expenseRepository
    }
    
    
    func execute(userEmail: String, startDate: Date, endDate: Date) -> AnyPublisher<(services: [ServiceResponse], expenses: [ExpenseResponse]), Error> {
        let services = serviceRepository.getAll(userEmail: userEmail, startDate: startDate, endDate: endDate)
        let expenses =  expenseRepository.getAll(userEmail: userEmail, startDate: startDate, endDate: endDate)
        
        return Publishers.Zip(services, expenses)
            .map { (services: $0, expenses: $1) }
            .eraseToAnyPublisher()
    }

    
    
}
