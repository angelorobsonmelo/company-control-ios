//
//  GetExpenseCategoriesUseCaseImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 17/05/2023.
//

import Foundation
import Combine

class GetCategoriesUseCaseImpl: GetCategoriesUseCase {
    
    let repository: CategoryRepository
    
    init(repository: CategoryRepository) {
        self.repository = repository
    }
    
    func execute(userEmail: String) -> AnyPublisher<[CategoryResponse], Error> {
       return repository.getAll(userEmail: userEmail)
    }
    
         
}
