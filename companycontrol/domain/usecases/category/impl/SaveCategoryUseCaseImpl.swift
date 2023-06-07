//
//  SaveExpenseCategoryUseCaseImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 17/05/2023.
//

import Foundation

class SaveCategoryUseCaseImpl: SaveCategoryUseCase {
    
    
    private let repository: CategoryRepository
    
    init(repository: CategoryRepository) {
        self.repository = repository
    }
    
    func saveCategory(request: CategoryRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        if(request.name.isEmpty) {
            completion(.failure(ValidationFormEnum.emptyField(reason: "Name can not be empty")))
            return
        }
        
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
