//
//  BalanceResponse.swift
//  companycontrol
//
//  Created by Ângelo Melo on 20/07/2023.
//

import Foundation

struct BalanceResponse {
    let services: [ServiceResponse]
    let expenses: [ExpenseResponse]
}
