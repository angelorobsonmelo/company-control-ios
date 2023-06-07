//
//  ExpenseCategoryRepository.swift
//  companycontrol
//
//  Created by Ângelo Melo on 17/05/2023.
//

import Foundation

protocol CategoryRepository {
    
    func getAll(userEmail: String, completion: @escaping (Result<[CategoryResponse], Error>) -> Void)
    func saveCategory(request: CategoryRequest, completion: @escaping (Result<Void, Error>) -> Void)
    func update(request: CategoryRequest, completion: @escaping (Result<Void, Error>) -> Void)
    func delete(id: String, completion: @escaping (Result<Void, Error>) -> Void)
    
}
