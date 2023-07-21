//
//  BalanceRemotaDataSource.swift
//  companycontrol
//
//  Created by Ângelo Melo on 20/07/2023.
//

import Foundation
import Combine


protocol BalanceRemotaDataSource {
    
    func getAll(userEmail: String, startDate: Date, endDate: Date) -> AnyPublisher<[BalanceResponse], Error>
    
}
