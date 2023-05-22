//
//  CurrencyFormatter.swift
//  companycontrol
//
//  Created by Ângelo Melo on 22/05/2023.
//

import Foundation


class CurrencyFormatter: NumberFormatter {
    override init() {
        super.init()
        self.numberStyle = .currency
        self.currencySymbol = "R$"
        self.maximumFractionDigits = 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
