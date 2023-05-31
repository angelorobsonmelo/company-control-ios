//
//  DoubleExtension.swift
//  companycontrol
//
//  Created by Ângelo Melo on 31/05/2023.
//

import Foundation

extension Double {
    
    func formatToCurrency(format: String = "pt_BR") -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: "pt_BR")
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
