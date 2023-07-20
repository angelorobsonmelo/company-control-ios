//
//  EditServiceUseCase.swift
//  companycontrol
//
//  Created by Ângelo Melo on 20/07/2023.
//

import Foundation


import Foundation
import Combine

protocol EditServiceUseCase {
    
    func execute(request: ServiceRequest) -> AnyPublisher<Void, Error>
}
