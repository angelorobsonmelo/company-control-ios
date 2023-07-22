//
//  StringExtensions.swift
//  companycontrol
//
//  Created by Ângelo Melo on 24/05/2023.
//

import Foundation

extension String {
    
    func formatStringDate(dateFormat: String = "dd MMM",
                          identifier: String = "en_US") -> String? {
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "dd-MM-yyyy"

            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = dateFormat
            dateFormatterPrint.locale = Locale(identifier: identifier)

            if let date = dateFormatterGet.date(from: self) {
                return dateFormatterPrint.string(from: date) // Retorna "20 May" ou o formato desejado
            } else {
               return nil // Retorna nil se a data não puder ser convertida
            }
        }
    
    func toDate(format: String = "dd/MM/yyyy") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            print("Invalid date string")
            return Date()
        }
    }
    
    var localized: String {
        let local = NSLocalizedString(self, tableName: "InfoPlist", comment: "")
        return local
    }
}
