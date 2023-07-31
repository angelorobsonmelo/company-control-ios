//
//  ScheduleRepository.swift
//  companycontrol
//
//  Created by Ângelo Melo on 31/07/2023.
//

import Foundation
import Combine

protocol ScheduleRepository {
    func save(request: ScheduleRequest) -> AnyPublisher<Void, Error>
    func getAll(userEmail: String, startDate: Date, endDate: Date) -> AnyPublisher<[ScheduleResponse], Error>
    func delete(id: String) -> AnyPublisher<Void, Error>
    func update(request: ScheduleRequest) -> AnyPublisher<Void, Error>
}
