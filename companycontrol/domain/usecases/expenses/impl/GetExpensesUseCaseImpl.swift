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
    
    func getAll(userEmail: String, completion: @escaping (Result<[ExpenseResponse], Error>) -> Void) {
        repository.getAll(userEmail: userEmail, completion: completion)
    }
 
    
}
