//
//  DeleteExpenseCategoryUseCase.swift
//  companycontrol
//
//  Created by Ângelo Melo on 18/05/2023.
//

import Foundation

protocol DeleteExpenseCategoryUseCase {
    
    func delete(id: String, completion: @escaping (Result<Void, Error>) -> Void)

}
