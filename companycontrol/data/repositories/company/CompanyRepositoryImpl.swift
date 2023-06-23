//
//  CompanyRepositoryImpl.swift
//  companycontrol
//
//  Created by Ângelo Melo on 07/06/2023.
//

import Foundation
import Combine

class CompanyRepositoryImpl: CompanyRepository {
    
    
    let dataSource: CompanyRemoteDataSource
    
    init(dataSource: CompanyRemoteDataSource) {
        self.dataSource = dataSource
    }
    
    func getAll(userEmail: String) -> AnyPublisher<[CompanyResponse], Error> {
       return dataSource.getAll(userEmail: userEmail)
    }
    
    func save(request: CompanyRequest) -> AnyPublisher<Void, Error> {
        dataSource.save(request: request)
    }
    
    func update(request: CompanyRequest) -> AnyPublisher<Void, Error> {
       return dataSource.update(request: request)
    }
    
    func delete(id: String) -> AnyPublisher<Void, Error> {
       return dataSource.delete(id: id)
    }
    
    
    
}
