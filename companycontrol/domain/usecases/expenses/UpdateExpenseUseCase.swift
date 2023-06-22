//
//  UpdateExpenseUseCase.swift
//  companycontrol
//
//  Created by Ângelo Melo on 31/05/2023.
//

import Foundation

protocol UpdateExpenseUseCase {
    func update(request: ExpenseRequest, completion: @escaping (Result<Void, Error>) -> Void)
}
