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
    
    
    
}
