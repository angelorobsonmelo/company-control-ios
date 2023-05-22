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

    @State private var expenses: [ExpensePresentation] = []
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(expenses, id: \.id) { item in
                        Text(item.title)
                    }
                    
                }
                
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
            .onAppear {
                self.viewModel.getExpenses()
            }
            .onChange(of: viewModel.getExpensesNetworkResult, perform: { newValue in
                switch newValue {
                case .success(let items):
                    self.expenses = items
                    break
                case .error(let message):
                    
                    break
                case .loading:
                    print("Loading")
                    break
                case .idle:
                    print("Idle")
                    break
                }
            })
            .sheet(isPresented: $showingAddDialog) {
                AddExpenseView(showingDialog: $showingAddDialog)
                    .environmentObject(viewModel)
            }
        }
       
    }
    
}
