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
    var date: String
    let expenseCategory: CategoryViewData
    
    static func oneInstance() -> ExpensePresentation {
        return ExpensePresentation(
            id: Utils.generateCustomID(),
            title: "Title",
            description: "Description",
            userEmail: "angelo@gmail.com",
            amount: 100.0,
            date: "12/12/2023",
            expenseCategory: CategoryViewData.onInstance())
    }
}
