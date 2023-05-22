//
//  ExpenseResponse.swift
//  companycontrol
//
//  Created by Ângelo Melo on 17/05/2023.
//

import Foundation

struct ExpenseResponse {
    let id: String
    let name: String
    let description: String
    let userEmail: String
    let value: Double
    let expenseCategoryId: String
}
