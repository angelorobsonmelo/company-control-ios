//
//  GetAllSchedulesUseCaseImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 31/07/2023.
//

import Foundation
import Combine

class GetAllSchedulesUseCaseImpl: GetAllSchedulesUseCase {
    
    let repository: ScheduleRepository
    
    init(repository: ScheduleRepository) {
        self.repository = repository
    }
    
    func execute(userEmail: String, startDate: Date, endDate: Date) -> AnyPublisher<[ScheduleResponse], Error> {
        return repository.getAll(userEmail: userEmail, startDate: startDate, endDate: endDate)
    }
    
    
}
