//
//  UpdateExpenseCategoryUseCase.swift
//  companycontrol
//
//  Created by Ângelo Melo on 18/05/2023.
//

import Foundation

protocol UpdateCategoryUseCase {
    
    func update(request: CategoryRequest, completion: @escaping (Result<Void, Error>) -> Void)
    
}

