//
//  ExpenseCategoryRepositoryImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 17/05/2023.
//

import Foundation

class ExpenseCategoryRepositoryImpl: ExpenseCategoryRepository {
    
    let dataSource: ExpenseCategoryRemoteDataSource
    
    init(dataSource: ExpenseCategoryRemoteDataSource) {
        self.dataSource = dataSource
    }
    
    func getAll(userEmail: String, completion: @escaping (Result<[ExpenseCategoryResponse], Error>) -> Void) {
        dataSource.getAll(userEmail: userEmail, completion: completion)
    }
    
    
    
}
