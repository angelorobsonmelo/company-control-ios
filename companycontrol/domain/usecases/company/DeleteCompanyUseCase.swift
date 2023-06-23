//
//  DeleteCompanyUseCase.swift
//  companycontrol
//
//  Created by Ângelo Melo on 07/06/2023.
//

import Foundation
import Combine

protocol DeleteCompanyUseCase {
    
    func execute(id: String) -> AnyPublisher<Void, Error>

}

