//
//  User.swift
//  companycontrol
//
//  Created by Ângelo Melo on 11/05/2023.
//

import Foundation


struct ExpensePresentation: Equatable, Identifiable {
    let id: String
    let title: String
    let description: String
    let userEmail: String
    let amount: Double
    let date: String
    let expenseCategory: ExpenseCategoryPresentation
}
