//
//  GetExpenseCategoriesUseCase.swift
//  companycontrol
//
//  Created by Ângelo Melo on 17/05/2023.
//

import Foundation

protocol GetCategoriesUseCase {
    
    func getAll(userEmail: String, completion: @escaping (Result<[CategoryResponse], Error>) -> Void)
}
