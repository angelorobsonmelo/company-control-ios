//
//  DeleteExpenseCategoryUseCaseImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 18/05/2023.
//

import Foundation

class DeleteExpenseCategoryUseCaseImpl: DeleteExpenseCategoryUseCase {
    
    let repository: ExpenseCategoryRepository
    
    init(repository: ExpenseCategoryRepository) {
        self.repository = repository
    }
    
    func delete(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        repository.delete(id: id, completion: completion)
    }
    
    
    
}
