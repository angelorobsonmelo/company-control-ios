//
//  UpdateExpenseUseCase.swift
//  companycontrol
//
//  Created by Ângelo Melo on 31/05/2023.
//

import Foundation

protocol UpdateExpenseUseCase {
    func updateExpense(request: ExpenseRequest, completion: @escaping (Result<Void, Error>) -> Void)
}
