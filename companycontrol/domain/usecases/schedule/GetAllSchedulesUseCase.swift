//
//  GetAllSchedulesUseCase.swift
//  companycontrol
//
//  Created by Ângelo Melo on 31/07/2023.
//

import Foundation
import Combine

protocol GetAllSchedulesUseCase {
    
    func execute(userEmail: String, startDate: Date, endDate: Date) -> AnyPublisher<[ScheduleResponse], Error>
}
