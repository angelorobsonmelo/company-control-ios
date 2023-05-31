//
//  ExpenseRepositoryImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 10/05/2023.
//

import Foundation

class ExpenseRepositoryImpl: ExpenseRepository {
    
    
    private let remoteDataSource: ExpenseRemoteDataSource
    
    init(remoteDataSource: ExpenseRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    func saveExpense(request: ExpenseRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        remoteDataSource.saveExpense(request: request, completion: completion)
    }
    
    func getAll(userEmail: String, startDate: Date, endDate: Date, completion: @escaping (Result<[ExpenseResponse], Error>) -> Void) {
        remoteDataSource.getAll(userEmail: userEmail, startDate: startDate, endDate: endDate, completion: completion)
    }
    
    func delete(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        remoteDataSource.delete(id: id, completion: completion)
    }
    
}
