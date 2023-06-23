//
//  ServiceRemoteDataSource.swift
//  companycontrol
//
//  Created by Ângelo Melo on 23/06/2023.
//

import Foundation
import Combine

protocol ServiceRemoteDataSource {
    
    func save(request: ServiceRequest) -> AnyPublisher<Void, Error>
    
}
