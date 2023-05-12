//
//  NetworkResult.swift
//  companycontrol
//
//  Created by Ângelo Melo on 11/05/2023.
//

import Foundation

enum NetworkResult<T: Equatable>: Equatable {
    case success(T)
    case error(String)
    case loading
    case idle
    
    static func == (lhs: NetworkResult<T>, rhs: NetworkResult<T>) -> Bool {
        switch (lhs, rhs) {
        case let (.success(leftValue), .success(rightValue)):
            return leftValue == rightValue
        case let (.error(leftMessage), .error(rightMessage)):
            return leftMessage == rightMessage
        case (.loading, .loading):
            return true
        case (.idle, .idle):
            return true
        default:
            return false
        }
    }
}

