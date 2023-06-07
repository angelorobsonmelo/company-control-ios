//
//  SaveExpenseCategoryUseCase.swift
//  companycontrol
//
//  Created by Ângelo Melo on 17/05/2023.
//

import Foundation

protocol SaveCategoryUseCase {
    
    func saveCategory(request: CategoryRequest, completion: @escaping (Result<Void, Error>) -> Void)

}
