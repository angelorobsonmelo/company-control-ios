//
//  ExpenseRepositoryImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 10/05/2023.
//

import Foundation
import Combine

class ExpenseRepositoryImpl: ExpenseRepository {
    
    
    private let remoteDataSource: ExpenseRemoteDataSource
    
    init(remoteDataSource: ExpenseRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    func saveExpense(request: ExpenseRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        remoteDataSource.saveExpense(request: request, completion: completion)
    }
    
    func editExpense(request: ExpenseRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        remoteDataSource.update(request: request, completion: completion)
    }
    
    func getAll(userEmail: String, startDate: Date, endDate: Date) -> AnyPublisher<[ExpenseResponse], Error> {
        return remoteDataSource.getAll(userEmail: userEmail, startDate: startDate, endDate: endDate)
    }
    
    func delete(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        remoteDataSource.delete(id: id, completion: completion)
    }
    
}
