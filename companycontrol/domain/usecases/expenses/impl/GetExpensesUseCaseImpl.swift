//
//  GetExpensesUseCase.swift
//  companycontrol
//
//  Created by Ângelo Melo on 11/05/2023.
//

import Foundation

class GetExpensesUseCaseImpl: GetExpensesUseCase {
    
    
    private let repository: ExpenseRepository
    
    init(repository: ExpenseRepository) {
        self.repository = repository
    }
    
    func saveExpense(request: ExpenseRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        
        if(request.name.isEmpty) {
            completion(.failure(ValidationFormEnum.emptyField(reason: "Name can not be empty")))
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
