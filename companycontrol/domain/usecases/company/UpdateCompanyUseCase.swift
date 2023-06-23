//
//  UpdateCompanyUseCase.swift
//  companycontrol
//
//  Created by Ângelo Melo on 07/06/2023.
//

import Foundation
import Combine

protocol UpdateCompanyUseCase {
    
    func execute(request: CompanyRequest) -> AnyPublisher<Void, Error>
}
