//
//  ExpenseCategoryPresentation.swift
//  companycontrol
//
//  Created by Ângelo Melo on 17/05/2023.
//

import Foundation

class CategoryViewData: Identifiable, Equatable {
    let id: String
    var name: String

    init(id: String, name: String) {
        self.id = id
        self.name = name
    }

    static func == (lhs: CategoryViewData, rhs: CategoryViewData) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func onInstance() -> CategoryViewData {
        return CategoryViewData(
            id: Utils.generateCustomID(),
            name: "Software")
    }
}
