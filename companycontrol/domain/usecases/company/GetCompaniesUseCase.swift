//
//  GetCompaniesUseCase.swift
//  companycontrol
//
//  Created by Ângelo Melo on 07/06/2023.
//

import Foundation
import Combine

protocol GetCompaniesUseCase {
    
    func execute(userEmail: String) -> AnyPublisher<[CompanyResponse], Error>
}
