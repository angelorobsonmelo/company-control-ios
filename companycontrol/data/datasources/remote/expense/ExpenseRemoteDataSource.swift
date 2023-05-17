//
//  ExpenseDataSource.swift
//  companycontrol
//
//  Created by Ângelo Melo on 10/05/2023.
//

import Foundation

protocol ExpenseRemoteDataSource {
    
    func saveExpense(request: ExpenseRequest, completion: @escaping (Result<Void, Error>) -> Void)
}
