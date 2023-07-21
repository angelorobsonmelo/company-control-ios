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
    
    func execute(userEmail: String, startDate: Date, endDate: Date) -> AnyPublisher<[ServiceResponse], Error> {
        
      return serviceRepository.getAll(userEmail: userEmail, startDate: startDate, endDate: endDate)
        
       
    }
    

}
