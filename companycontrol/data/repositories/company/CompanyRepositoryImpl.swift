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
    
    func update(request: CompanyRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        dataSource.update(request: request, completion: completion)
    }
    
    func delete(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        dataSource.delete(id: id, completion: completion)
    }
    
    
    
}
