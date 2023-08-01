//
//  DeleteScheduleUseCaseImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 31/07/2023.
//

import Foundation
import Combine

class DeleteScheduleUseCaseImpl: DeleteScheduleUseCase {
    
    let repository: ScheduleRepository
    
    init(repository: ScheduleRepository) {
        self.repository = repository
    }
    
    func execute(id: String) -> AnyPublisher<Void, Error> {
       return repository.delete(id: id)
    }
    
    
    
}
