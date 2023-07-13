//
//  DeleteServiceUseCase.swift
//  companycontrol
//
//  Created by Ângelo Melo on 13/07/2023.
//

import Foundation
import Combine

protocol DeleteServiceUseCase {
    
    func execute(id: String) -> AnyPublisher<Void, Error>

}
