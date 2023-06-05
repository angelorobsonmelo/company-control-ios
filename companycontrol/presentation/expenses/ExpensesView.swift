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
    
    @State private var showingEditDialog = false
    @State private var selectedExpense: ExpensePresentation? = nil
    
    
    let calendar = Calendar.current
    let now = Date()
    
    @State private var startDate = Date()
    @State private var endDate =  Date()
    
    @State private var showingDeleteConfirmation = false
    @State private var itemPosition: Int? = nil
    @State private var dateGroupToDelete: String = ""
    
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Total: \(viewModel.totalAmount.formatToCurrency())")
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
                                            .foregroundColor(.secondary)
                                            .font(.body)
                                        
                                        Spacer()
                                        
                                        Text(item.amount.formatToCurrency())
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    showingEditDialog = true
                                    selectedExpense = item
                                    print(item.amount)
                                }
                            }
                            .onDelete(perform: { indexSet in
                                deleteCategory(at: indexSet, date: date)
                            })
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
            AddExpenseView(showingDialog: $showingAddDialog) {
                self.viewModel.getExpenses(startDate: startDate, endDate: endDate)
            }
            .environmentObject(viewModel)
        }
        .sheet(isPresented: $showingEditDialog) {
            EditExpenseView(showingDialog: $showingEditDialog, expense: self.selectedExpense!) {
                
            }
            .environmentObject(viewModel)
        }
        .alert(isPresented: $showingDeleteConfirmation) {
            Alert(
                title: Text("Delete Category"),
                message: Text("Are you sure you want to delete this category?"),
                primaryButton: .destructive(Text("Delete")) {
                    
                    viewModel.deleteExpense(at: itemPosition!, from: dateGroupToDelete)
                },
                secondaryButton: .cancel {
                    
                }
            )
        }
        .onChange(of: selectedExpense) { newCategory in
            if let newExpense = selectedExpense {
                self.selectedExpense = newExpense
                self.showingEditDialog = true
            }
        }
    }
    
    
    private func deleteCategory(at offsets: IndexSet, date: String) {
        self.showingDeleteConfirmation = true
        self.itemPosition = offsets.first!
        self.dateGroupToDelete = date
        
    }
    
}
