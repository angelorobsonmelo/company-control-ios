//
//  SnackbarType.swift
//  companycontrol
//
//  Created by Ângelo Melo on 12/05/2023.
//

import Foundation
import SwiftUI

enum SnackbarType {
    case success
    case error
    
    var backgroundColor: Color {
        switch self {
        case .success:
            return .green
        case .error:
            return .red
        }
    }
}
