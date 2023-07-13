//
//  CompanyViewData.swift
//  companycontrol
//
//  Created by Ângelo Melo on 07/06/2023.
//

import Foundation


import Foundation

struct CompanyViewData: Identifiable, Equatable {
    let id: String
    let address: String
    let contactNumber: String
    let name: String
    let userEmail: String
    
    static func oneInstance() -> CompanyViewData {
        return CompanyViewData(
            id: Utils.generateCustomID(),
            address: "address 1",
            contactNumber: "contact number 1",
            name: "name 1",
            userEmail: "test@gmail.com"
        )
    }
}
