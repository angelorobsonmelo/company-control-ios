//
//  NetworkResult.swift
//  companycontrol
//
//  Created by Ângelo Melo on 11/05/2023.
//

import Foundation

enum NetworkResult<T: Equatable>: Equatable {
    case success(T)
    case error(String, Date)
    case loading
    case idle
    
}

