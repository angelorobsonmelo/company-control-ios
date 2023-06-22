//
//  CompanyRemoteDataSource.swift
//  companycontrol
//
//  Created by Ângelo Melo on 07/06/2023.
//

import Foundation
import Combine

protocol CompanyRemoteDataSource {
    
    func getAll(userEmail: String) -> AnyPublisher<[CompanyResponse], Error>
    func save(request: CompanyRequest, completion: @escaping (Result<Void, Error>) -> Void)
    func update(request: CompanyRequest, completion: @escaping (Result<Void, Error>) -> Void)
    func delete(id: String, completion: @escaping (Result<Void, Error>) -> Void)
    
}
