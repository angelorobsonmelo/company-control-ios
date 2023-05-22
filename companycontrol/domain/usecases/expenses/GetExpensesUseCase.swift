//
//  GetExpensesUseCase.swift
//  companycontrol
//
//  Created by Ângelo Melo on 11/05/2023.
//

import Foundation

protocol GetExpensesUseCase {
    func getAll(userEmail: String, completion: @escaping (Result<[ExpenseResponse], Error>) -> Void)
}
