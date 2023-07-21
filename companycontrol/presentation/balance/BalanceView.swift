//
//  BalanceView.swift
//  companycontrol
//
//  Created by Ângelo Melo on 21/07/2023.
//

import Foundation
import SwiftUI

struct BalanceView: View {
    
    @StateObject var viewModel = DIContainer.shared.resolve(BalanceViewModel.self)
    @State private var showingAddDialog = false
    
    @State private var showingEditDialog = false
    
    
    let calendar = Calendar.current
    let now = Date()
    
    @State private var startDate = Date()
    @State private var endDate =  Date()
        
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Total: \(self.viewModel.balanceViews?.total.formatToCurrency() ?? "")")
                    .font(.headline)
                    .padding(.top, 16)
                
                HStack {
                    DatePicker("", selection: $startDate, displayedComponents: .date)
                        .labelsHidden()
                        .onChange(of: startDate) { newValue in
                            self.viewModel.getBalance(startDate: startDate, endDate: endDate)
                        }
                    
                    DatePicker("", selection: $endDate, displayedComponents: .date)
                        .labelsHidden()
                        .onChange(of: endDate) { newValue in
                            self.viewModel.getBalance(startDate: startDate, endDate: endDate)
                        }
                }
                .padding()
                
                
                List {
                    VStack {
                        HStack {
                            Text("Total expenses:")
                                .font(.headline)
                            Spacer()
                            Text(viewModel.balanceViews?.totalExpenses.formatToCurrency() ?? "")
                        }
                        .padding(.bottom, 10)
                        
                        HStack {
                            Text("Total Services:")
                                .foregroundColor(.secondary)
                                .font(.body)
                            
                            Spacer()
                            
                            Text(viewModel.balanceViews?.totalServices.formatToCurrency() ?? "")
                                .foregroundColor(.secondary)
                        }
                        .padding(.bottom, 10)
                        
                    }
                    .contentShape(Rectangle())
                }
                .navigationBarTitle("Balance", displayMode: .inline)
    
            }
            
            .onAppear {
                self.startDate = self.calendar.dateInterval(of: .month, for: now)?.start ?? Date()
                self.endDate = Date()
                
                self.viewModel.getBalance(startDate: startDate, endDate: endDate)
            }
        }
    }
    
}

