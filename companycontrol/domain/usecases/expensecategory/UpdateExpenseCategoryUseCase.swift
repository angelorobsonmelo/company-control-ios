//
//  UpdateExpenseCategoryUseCase.swift
//  companycontrol
//
//  Created by Ângelo Melo on 18/05/2023.
//

import Foundation

protocol UpdateExpenseCategoryUseCase {
    
    func update(request: ExpenseCategoryRequest, completion: @escaping (Result<Void, Error>) -> Void)
    
}

