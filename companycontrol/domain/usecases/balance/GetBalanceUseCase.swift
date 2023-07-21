//
//  GetBalanceUseCase.swift
//  companycontrol
//
//  Created by Ângelo Melo on 20/07/2023.
//

import Foundation
import Combine

protocol GetBalanceUseCase {
    
    func execute(userEmail: String, startDate: Date, endDate: Date) -> AnyPublisher<(services: [ServiceResponse], expenses: [ExpenseResponse]), Error> 
}
