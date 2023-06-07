//
//  UpdateExpenseCategoryUseCaseImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 18/05/2023.
//

import Foundation

class UpdateCategoryUseCaseImpl: UpdateCategoryUseCase {
    
    let repository: CategoryRepository
    
    init(repository: CategoryRepository) {
        self.repository = repository
    }
    
    func update(request: CategoryRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        repository.update(request: request, completion: completion)
    }
    
    
    
}
