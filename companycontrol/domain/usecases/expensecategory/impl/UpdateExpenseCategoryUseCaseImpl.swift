//
//  UpdateExpenseCategoryUseCaseImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 18/05/2023.
//

import Foundation

class UpdateExpenseCategoryUseCaseImpl: UpdateExpenseCategoryUseCase {
    
    let repository: ExpenseCategoryRepository
    
    init(repository: ExpenseCategoryRepository) {
        self.repository = repository
    }
    
    func update(request: ExpenseCategoryRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        repository.update(request: request, completion: completion)
    }
    
    
    
}
