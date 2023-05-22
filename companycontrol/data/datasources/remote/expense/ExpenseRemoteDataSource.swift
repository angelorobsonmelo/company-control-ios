//
//  ExpenseDataSource.swift
//  companycontrol
//
//  Created by Ângelo Melo on 10/05/2023.
//

import Foundation

protocol ExpenseRemoteDataSource {
    
    func saveExpense(request: ExpenseRequest, completion: @escaping (Result<Void, Error>) -> Void)
    func update(request: ExpenseRequest, completion: @escaping (Result<Void, Error>) -> Void)
    func delete(id: String, completion: @escaping (Result<Void, Error>) -> Void)
    func getAll(userEmail: String, completion: @escaping (Result<[ExpenseResponse], Error>) -> Void)
}
