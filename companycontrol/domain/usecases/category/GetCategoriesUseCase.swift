//
//  GetExpenseCategoriesUseCase.swift
//  companycontrol
//
//  Created by Ângelo Melo on 17/05/2023.
//

import Foundation
import Combine

protocol GetCategoriesUseCase {
    
    func execute(userEmail: String) -> AnyPublisher<[CategoryResponse], Error>
}
