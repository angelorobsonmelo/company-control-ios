//
//  ScheduleRepositoryImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 31/07/2023.
//

import Foundation
import Combine

class ScheduleRepositoryImpl: ScheduleRepository {
    
    let dataSource: ScheduleRemoteDataSource
    
    init(dataSource: ScheduleRemoteDataSource) {
        self.dataSource = dataSource
    }
    
    func save(request: ScheduleRequest) -> AnyPublisher<Void, Error> {
        return dataSource.save(request: request)
    }
    
    func getAll(userEmail: String, startDate: Date, endDate: Date) -> AnyPublisher<[ScheduleResponse], Error> {
        return dataSource.getAll(userEmail: userEmail, startDate: startDate, endDate: endDate)
    }
    
    func delete(id: String) -> AnyPublisher<Void, Error> {
        return dataSource.delete(id: id)
    }
    
    func update(request: ScheduleRequest) -> AnyPublisher<Void, Error> {
        return dataSource.update(request: request)
    }
    
    
    
}
