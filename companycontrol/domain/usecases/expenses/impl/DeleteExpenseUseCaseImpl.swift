//
//  DeleteExpenseImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 29/05/2023.
//

import Foundation

class DeleteExpenseUseCaseImpl: DeleteExpenseUseCase {
    
    
    let dataSource: ExpenseRepository
    
    init(dataSource: ExpenseRepository) {
        self.dataSource = dataSource
    }
    
    func delete(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        dataSource.delete(id: id, completion: completion)
    }
    
    
}
