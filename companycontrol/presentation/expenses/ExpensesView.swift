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
    
    @State private var expenses: [String: [ExpensePresentation]] = [:]
    
    let calendar = Calendar.current
    let now = Date()
    
    @State private var startDate = Date()
    @State private var endDate =  Date()
    
    
    
    var totalAmount: Double {
        expenses.values.flatMap { $0 }.reduce(0) { $0 + $1.amount }
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Total: \(formatToReal(amount: totalAmount))")
                    .font(.headline)
                    .padding(.top, 16)
                
                HStack {
                    DatePicker("", selection: $startDate, displayedComponents: .date)
                        .labelsHidden()
                        .onChange(of: startDate) { newValue in
                            self.viewModel.getExpenses(startDate: startDate, endDate: endDate)
                        }
                    
                    DatePicker("", selection: $endDate, displayedComponents: .date)
                        .labelsHidden()
                        .onChange(of: endDate) { newValue in
                            self.viewModel.getExpenses(startDate: startDate, endDate: endDate)
                        }
                }
                .padding()
                
                
                List {
                    ForEach(viewModel.sortedDates, id: \.self) { date in
                    
                        Section(header: Text(date)) {
                            ForEach(viewModel.groupedCosts[date]!, id: \.id) { item in
                                VStack {
                                    HStack {
                                        Text(item.title)
                                            .font(.headline)
                                        Spacer()
                                        Text(item.expenseCategory.name)
                                    }
                                    .padding(.bottom, 10)
                                    
                                    HStack {
                                        Text(item.description)
                                            .font(.body)
                                        Spacer()
                                        Text(formatToReal(amount: item.amount))
                                    }
                                }
                            }
                        }
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
            
        }
        
        .onAppear {
            self.startDate = self.calendar.dateInterval(of: .month, for: now)?.start ?? Date()
            self.endDate = self.calendar.dateInterval(of: .month, for: now)?.end ?? Date()
            
            self.viewModel.getExpenses(startDate: startDate, endDate: endDate)
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
    
    func formatToReal(amount: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: "pt_BR")
        return numberFormatter.string(from: NSNumber(value: amount)) ?? ""
    }
    
}
