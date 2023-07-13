//
//  ServiceViewData.swift
//  companycontrol
//
//  Created by Ângelo Melo on 13/07/2023.
//



struct ServiceViewData: Equatable, Identifiable {
    let id: String
    let title: String
    let description: String
    let userEmail: String
    let amount: Double
    var date: String
    let expenseCategory: CategoryViewData
    let company: CompanyViewData
    
    static func oneInstance() -> ServiceViewData {
        return ServiceViewData(
            id: Utils.generateCustomID(),
            title: "Title",
            description: "Description",
            userEmail: "angelo@gmail.com",
            amount: 100.0,
            date: "12/12/2023",
            expenseCategory: CategoryViewData.onInstance(),
            company: CompanyViewData.oneInstance()
        )
    }
}
