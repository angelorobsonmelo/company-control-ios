//
//  SaveCompanyUseCase.swift
//  companycontrol
//
//  Created by Ângelo Melo on 07/06/2023.
//

import Foundation
import Combine

protocol SaveCompanyUseCase {
    func execute(request: CompanyRequest) -> AnyPublisher<Void, Error>

}
