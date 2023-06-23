//
//  SaveServiceUseCase.swift
//  companycontrol
//
//  Created by Ângelo Melo on 23/06/2023.
//

import Foundation
import Combine

protocol SaveServiceUseCase {
    
    func execute(request: ServiceRequest) -> AnyPublisher<Void, Error>
}
