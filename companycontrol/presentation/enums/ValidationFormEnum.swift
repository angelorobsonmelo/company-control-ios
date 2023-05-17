//
//  ValidationFormEnum.swift
//  companycontrol
//
//  Created by Ângelo Melo on 17/05/2023.
//

import Foundation

enum ValidationFormEnum: Error, LocalizedError {
    case emptyField(reason: String)
    
    var errorDescription: String? {
        switch self {
        case .emptyField(let reason):
            return reason
        }
    }
}
