//
//  ExpenseCategoryRepository.swift
//  companycontrol
//
//  Created by Ângelo Melo on 17/05/2023.
//

import Foundation
import Combine

protocol CategoryRepository {
    
    func getAll(userEmail: String) -> AnyPublisher<[CategoryResponse], Error>
    func saveCategory(request: CategoryRequest, completion: @escaping (Result<Void, Error>) -> Void)
    func update(request: CategoryRequest, completion: @escaping (Result<Void, Error>) -> Void)
    func delete(id: String, completion: @escaping (Result<Void, Error>) -> Void)
    
}
