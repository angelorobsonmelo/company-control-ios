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
    
    func test() {
        repository.save()
    }
    
    
}
