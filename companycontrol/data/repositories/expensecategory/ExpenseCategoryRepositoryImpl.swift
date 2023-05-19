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
    
    func saveCategory(request: ExpenseCategoryRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        dataSource.saveCategory(request: request, completion: completion)
    }
    
    func update(request: ExpenseCategoryRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        dataSource.update(request: request, completion: completion)
    }
    
    func delete(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        dataSource.delete(id: id, completion: completion)
    }

    
    
}
