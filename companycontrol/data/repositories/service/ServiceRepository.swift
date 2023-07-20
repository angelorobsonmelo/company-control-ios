//
//  ServiceRepository.swift
//  companycontrol
//
//  Created by Ângelo Melo on 23/06/2023.
//

import Foundation
import Combine

protocol ServiceRepository {
    
    func save(request: ServiceRequest) -> AnyPublisher<Void, Error>
    func getAll(userEmail: String, startDate: Date, endDate: Date) -> AnyPublisher<[ServiceResponse], Error>
    func delete(id: String) -> AnyPublisher<Void, Error>
    func update(request: ServiceRequest) -> AnyPublisher<Void, Error>
    
}
