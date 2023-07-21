//
//  GetExpensesUseCase.swift
//  companycontrol
//
//  Created by Ângelo Melo on 11/05/2023.
//

import Foundation
import Combine

class GetExpensesUseCaseImpl: GetExpensesUseCase {
    
        
    private let repository: ExpenseRepository
    
    init(repository: ExpenseRepository) {
        self.repository = repository
    }
    
    func execute(userEmail: String, startDate: Date, endDate: Date) -> AnyPublisher<[ExpenseResponse], Error> {
        return repository.getAll(userEmail: userEmail, startDate: startDate, endDate: endDate)
    }
 
    
}
