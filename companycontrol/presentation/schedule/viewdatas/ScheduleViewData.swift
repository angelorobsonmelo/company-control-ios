//
//  ScheduleViewData.swift
//  companycontrol
//
//  Created by Ângelo Melo on 31/07/2023.
//

import Foundation

struct ScheduleViewData: Identifiable, Equatable {
    let id: String
    let title: String
    let description: String
    let date: String
    let userEmail: String
    let completed: Bool
}
