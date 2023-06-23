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
    
    
}
