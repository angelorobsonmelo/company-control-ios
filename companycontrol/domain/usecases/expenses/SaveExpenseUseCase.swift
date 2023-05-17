//
//  SaveExpenseUseCase.swift
//  companycontrol
//
//  Created by Ângelo Melo on 17/05/2023.
//

import Foundation

protocol SaveExpenseUseCase {
    func saveExpense(request: ExpenseRequest, completion: @escaping (Result<Void, Error>) -> Void)
}
