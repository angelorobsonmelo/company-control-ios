//
//  ServiceRepositoryImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 23/06/2023.
//

import Foundation
import Combine

class ServiceRepositoryImpl: ServiceRepository {
    
    
    let dataSource: ServiceRemoteDataSource
    
    init(dataSource: ServiceRemoteDataSource) {
        self.dataSource = dataSource
    }
    
    func save(request: ServiceRequest) -> AnyPublisher<Void, Error> {
        return dataSource.save(request: request)
    }
    
    func update(request: ServiceRequest) -> AnyPublisher<Void, Error> {
        return dataSource.update(request: request)
    }
    
    func getAll(userEmail: String, startDate: Date, endDate: Date) -> AnyPublisher<[ServiceResponse], Error> {
        return dataSource.getAll(userEmail: userEmail, startDate: startDate, endDate: endDate)
    }
    
    func delete(id: String) -> AnyPublisher<Void, Error> {
        return dataSource.delete(id: id)
    }

    
}
