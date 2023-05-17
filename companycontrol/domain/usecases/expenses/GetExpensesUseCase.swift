//
//  GetExpensesUseCase.swift
//  companycontrol
//
//  Created by Ângelo Melo on 11/05/2023.
//

import Foundation

protocol GetExpensesUseCase {
    func saveExpense(request: ExpenseRequest, completion: @escaping (Result<Void, Error>) -> Void)
}
