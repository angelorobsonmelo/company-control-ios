//
//  GetExpensesUseCase.swift
//  companycontrol
//
//  Created by Ângelo Melo on 11/05/2023.
//

import Foundation

class GetExpensesUseCaseImpl: GetExpensesUseCase {
    
        
    private let repository: ExpenseRepository
    
    init(repository: ExpenseRepository) {
        self.repository = repository
    }
    
    func getAll(userEmail: String, startDate: Date, endDate: Date, completion: @escaping (Result<[ExpenseResponse], Error>) -> Void) {
        repository.getAll(userEmail: userEmail, startDate: startDate, endDate: endDate, completion: completion)
    }
 
    
}
