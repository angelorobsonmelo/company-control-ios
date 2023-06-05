//
//  UpdateExpenseUseCaseImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 31/05/2023.
//

import Foundation

class UpdateExpenseUseCaseImpl: UpdateExpenseUseCase {
    
    let repository: ExpenseRepository
    
    init(repository: ExpenseRepository) {
        self.repository = repository
    }
    
    func updateExpense(request: ExpenseRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        guard !request.title.isEmpty else {
            completion(.failure(ValidationFormEnum.emptyField(reason: "Title can not be empty")))
            return
        }
        
        guard !request.description.isEmpty else {
            completion(.failure(ValidationFormEnum.emptyField(reason: "Description can not be empty")))
            return
        }
        
        guard request.amount > 0 else {
            completion(.failure(ValidationFormEnum.emptyField(reason: "Amount must be greater than zero")))
            return
        }
        
        guard !request.expenseCategoryId.isEmpty else {
            completion(.failure(ValidationFormEnum.emptyField(reason: "Category can not be empty")))
            return
        }

        repository.editExpense(request: request) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
}
