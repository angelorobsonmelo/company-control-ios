//
//  EditScheduleUseCase.swift
//  companycontrol
//
//  Created by Ângelo Melo on 31/07/2023.
//

import Foundation
import Combine

protocol EditScheduleUseCase {
    
    func execute(request: ScheduleRequest) -> AnyPublisher<Void, Error>

}
