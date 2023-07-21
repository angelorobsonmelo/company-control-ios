//
//  GetExpensesUseCase.swift
//  companycontrol
//
//  Created by Ângelo Melo on 11/05/2023.
//

import Foundation
import Combine

protocol GetExpensesUseCase {
    
    func execute(userEmail: String, startDate: Date, endDate: Date) -> AnyPublisher<[ExpenseResponse], Error>
    
}
