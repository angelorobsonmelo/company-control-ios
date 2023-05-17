//
//  SaveExpenseCategoryUseCaseImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 17/05/2023.
//

import Foundation

class SaveExpenseCategoryUseCaseImpl: SaveExpenseCategoryUseCase {
    
    
    private let repository: ExpenseCategoryRepository
    
    init(repository: ExpenseCategoryRepository) {
        self.repository = repository
    }
    
    func saveCategory(request: ExpenseCategoryRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        repository.saveCategory(request: request) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}