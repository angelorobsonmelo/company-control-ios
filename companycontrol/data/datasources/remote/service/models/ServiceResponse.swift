//
//  ServiceResponse.swift
//  companycontrol
//
//  Created by Ângelo Melo on 13/07/2023.
//

import Foundation

struct ServiceResponse {
    let id: String
    let title: String
    let description: String
    let userEmail: String
    let amount: Double
    let date: String
    let category: CategoryResponse
    let company: CompanyResponse
}
