//
//  ExpenseRequest.swift
//  companycontrol
//
//  Created by Ângelo Melo on 16/05/2023.
//

import Foundation

struct ExpenseRequest {
    let id: String
    let title: String
    let description: String
    let userEmail: String
    let amount: Double
    let expenseCategoryId: String
    let date: Date
}
