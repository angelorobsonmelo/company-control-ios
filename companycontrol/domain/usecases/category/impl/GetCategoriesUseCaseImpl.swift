//
//  GetExpenseCategoriesUseCaseImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 17/05/2023.
//

import Foundation

class GetCategoriesUseCaseImpl: GetCategoriesUseCase {
    
    let repository: CategoryRepository
    
    init(repository: CategoryRepository) {
        self.repository = repository
    }
    
    func getAll(userEmail: String, completion: @escaping (Result<[CategoryResponse], Error>) -> Void) {
        repository.getAll(userEmail: userEmail, completion: completion)
    }
    
         
}
