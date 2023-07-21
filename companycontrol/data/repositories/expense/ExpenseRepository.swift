//
//  ExpenseRepository.swift
//  companycontrol
//
//  Created by Ângelo Melo on 10/05/2023.
//

import Foundation
import Combine

protocol ExpenseRepository {
    func saveExpense(request: ExpenseRequest, completion: @escaping (Result<Void, Error>) -> Void)
    func editExpense(request: ExpenseRequest, completion: @escaping (Result<Void, Error>) -> Void)
    func getAll(userEmail: String, startDate: Date, endDate: Date) -> AnyPublisher<[ExpenseResponse], Error>
    func delete(id: String, completion: @escaping (Result<Void, Error>) -> Void)

}
