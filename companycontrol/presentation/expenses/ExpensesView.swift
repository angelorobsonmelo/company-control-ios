//
//  ExpensesView.swift
//  companycontrol
//
//  Created by Ângelo Melo on 11/05/2023.
//

import Foundation
import SwiftUI

struct ExpensesView: View {
    
    @ObservedObject var viewModel = DIContainer.shared.resolve(ExpenseViewModel.self)

    
    var body: some View {
           VStack {
               Text("")
           }
       }
}
