//
//  SaveExpenseUseCaseImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 17/05/2023.
//

import Foundation

class SaveExpenseUseCaseImpl: SaveExpenseUseCase {
    
    
    private let repository: ExpenseRepository
    
    init(repository: ExpenseRepository) {
        self.repository = repository
    }
    
    func saveExpense(request: ExpenseRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        
        if(request.title.isEmpty) {
            completion(.failure(ValidationFormEnum.emptyField(reason: "Title can not be empty")))
        }
        
        if(request.description.isEmpty) {
            completion(.failure(ValidationFormEnum.emptyField(reason: "Description can not be empty")))
        }
        
        if(request.expenseCategoryId.isEmpty) {
            completion(.failure(ValidationFormEnum.emptyField(reason: "Category can not be empty")))
        }

        
        repository.saveExpense(request: request) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}

