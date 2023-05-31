//
//  DeleteExpense.swift
//  companycontrol
//
//  Created by Ângelo Melo on 29/05/2023.
//

import Foundation

protocol DeleteExpenseUseCase {
    
    func delete(id: String, completion: @escaping (Result<Void, Error>) -> Void)
    
}
