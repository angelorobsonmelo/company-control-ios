//
//  CompanyRepository.swift
//  companycontrol
//
//  Created by Ângelo Melo on 07/06/2023.
//

import Foundation
import Combine

protocol CompanyRepository {
    
    func getAll(userEmail: String) -> AnyPublisher<[CompanyResponse], Error>
    func save(request: CompanyRequest) -> AnyPublisher<Void, Error>
    func update(request: CompanyRequest, completion: @escaping (Result<Void, Error>) -> Void)
    func delete(id: String) -> AnyPublisher<Void, Error>
    
}
