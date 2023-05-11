//
//  NetworkResult.swift
//  companycontrol
//
//  Created by Ângelo Melo on 11/05/2023.
//

import Foundation

enum NetworkResult<T> {
    case success(T?)
    case error(String?)
    case loading
    case idle
}
