//
//  ScheduleRequest.swift
//  companycontrol
//
//  Created by Ângelo Melo on 31/07/2023.
//

import Foundation

struct ScheduleRequest {
    let id: String
    let title: String
    let description: String
    let date: Date
    let userEmail: String
    let completed: Bool
}
