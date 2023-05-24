//
//  ExpenseRepository.swift
//  companycontrol
//
//  Created by Ângelo Melo on 10/05/2023.
//

import Foundation

protocol ExpenseRepository {
    func saveExpense(request: ExpenseRequest, completion: @escaping (Result<Void, Error>) -> Void)
    func getAll(userEmail: String, startDate: Date, endDate: Date, completion: @escaping (Result<[ExpenseResponse], Error>) -> Void)

}
