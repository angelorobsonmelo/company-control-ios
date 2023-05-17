//
//  SaveExpenseCategoryUseCase.swift
//  companycontrol
//
//  Created by Ângelo Melo on 17/05/2023.
//

import Foundation

protocol SaveExpenseCategoryUseCase {
    
    func saveCategory(request: ExpenseCategoryRequest, completion: @escaping (Result<Void, Error>) -> Void)

}
