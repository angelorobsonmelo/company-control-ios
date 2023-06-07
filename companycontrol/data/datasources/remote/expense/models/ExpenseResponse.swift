//
//  ExpenseResponse.swift
//  companycontrol
//
//  Created by Ângelo Melo on 17/05/2023.
//

import Foundation

struct ExpenseResponse {
    let id: String
    let title: String
    let description: String
    let userEmail: String
    let amount: Double
    let date: String
    let category: CategoryResponse
}
