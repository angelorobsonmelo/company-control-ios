//
//  DateExtension.swift
//  companycontrol
//
//  Created by Ângelo Melo on 24/05/2023.
//

import Foundation

extension Date {
    
    func formaterDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: self)
    }
    
}
