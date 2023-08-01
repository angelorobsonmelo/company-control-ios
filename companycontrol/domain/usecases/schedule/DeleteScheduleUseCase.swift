//
//  DeleteScheduleUseCase.swift
//  companycontrol
//
//  Created by Ângelo Melo on 31/07/2023.
//

import Foundation
import Combine

protocol DeleteScheduleUseCase {
    
    func execute(id: String) -> AnyPublisher<Void, Error>

}
