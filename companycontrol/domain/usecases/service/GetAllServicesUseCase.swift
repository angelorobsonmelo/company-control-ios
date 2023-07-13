//
//  GetAllServices.swift
//  companycontrol
//
//  Created by Ângelo Melo on 13/07/2023.
//

import Foundation
import Combine

protocol GetAllServiceUseCase {
    
    func execute(userEmail: String, startDate: Date, endDate: Date) -> AnyPublisher<[ServiceResponse], Error>
}
