//
//  GetExpenseCategoriesUseCaseImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 17/05/2023.
//

import Foundation

class GetExpenseCategoriesUseCaseImpl: GetExpenseCategoriesUseCase {
    
    let repository: ExpenseCategoryRepository
    
    init(repository: ExpenseCategoryRepository) {
        self.repository = repository
    }
    
    func getAll(userEmail: String, completion: @escaping (Result<[ExpenseCategoryResponse], Error>) -> Void) {
        repository.getAll(userEmail: userEmail, completion: completion)
    }
    
         
}
