//
//  ExpensesView.swift
//  companycontrol
//
//  Created by Ângelo Melo on 11/05/2023.
//

import Foundation
import SwiftUI

struct ExpensesView: View {
    
    @StateObject var viewModel = DIContainer.shared.resolve(ExpenseViewModel.self)
    @State private var showingAddDialog = false

    
    var body: some View {
        NavigationView {
            VStack {
                Text("expenses soon")
            }
            .navigationBarTitle("Expenses", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.showingAddDialog = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddDialog) {
                AddExpenseView(showingDialog: $showingAddDialog)
                    .environmentObject(viewModel)
            }
        }
       
    }
    
}
