//
//  ExpenseCategoryRemoteDataSource.swift
//  companycontrol
//
//  Created by Ângelo Melo on 17/05/2023.
//

import Foundation

protocol ExpenseCategoryRemoteDataSource {
    
    func getAll(userEmail: String, completion: @escaping (Result<[ExpenseCategoryResponse], Error>) -> Void)
    func saveCategory(request: ExpenseCategoryRequest, completion: @escaping (Result<Void, Error>) -> Void)
}
