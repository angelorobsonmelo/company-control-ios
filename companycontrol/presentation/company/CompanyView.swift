//
//  CompanyView.swift
//  companycontrol
//
//  Created by Ângelo Melo on 07/06/2023.
//

import SwiftUI

struct CompanyView: View {
    
    @StateObject var viewModel = DIContainer.shared.resolve(CompanyViewModel.self)
    
    
    @State private var showingAddDialog = false
    @State private var showingEditDialog = false
    
    @State private var showingDeleteConfirmation = false
    
    @State private var itemPosition: Int? = nil
    @State private var selectedCompany: CompanyViewData? = nil
    
    var body: some View {
        NavigationView {
            switch viewModel.loadingState {
            case .idle:
                EmptyView()
                
            case .loading:
                ProgressView()
                
            case .failed(let error):
                VStack {
                    Text("Error: \(error.localizedDescription)")
                    Button("Try Again") {
                        viewModel.getCompanies()
                    }
                }
            case .succeeded(let companies):
                VStack {
                    List {
                        ForEach(companies, id: \.id) { company in
                            VStack {
                                HStack {
                                    Text(company.name)
                                    Spacer()
                                    Text(company.contactNumber)
                                }
                                
                                
                                HStack {
                                    Text(company.address)
                                        .foregroundColor(.secondary)
                                        .font(.body)
                                    
                                    Spacer()
                                }
                                
                            }
                            .contentShape(Rectangle())
                            .background(Color.clear)
                            .onTapGesture {
                                self.selectedCompany = company
                                self.showingEditDialog = true
                            }
                        }
                        .onDelete(perform: deleteCategory)
                    }
                    
                }
                .navigationBarTitle("COMPANIES".localized, displayMode: .inline)
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
                    AddCompanyView(showingDialog: $showingAddDialog)
                        .environmentObject(viewModel)
                }
                .sheet(isPresented: $showingEditDialog, onDismiss: {
                       self.selectedCompany = nil
                   }, content: {
                       EditCompanyView(company: selectedCompany!, showingDialog: $showingEditDialog)
                           .environmentObject(viewModel)
                   })
                .alert(isPresented: $showingDeleteConfirmation) {
                    Alert(
                        title: Text("DELETE".localized),
                        message: Text("DELETE_ITEM_MSG".localized),
                        primaryButton: .destructive(Text("DELETE".localized)) {
                            viewModel.remove(id: companies[itemPosition!].id)
                            
                        },
                        secondaryButton: .cancel {
                            
                        }
                    )
                }
                .onChange(of: selectedCompany) { newCategory in
                    if let newCategory = newCategory {
                        self.selectedCompany = newCategory
                        self.showingEditDialog = true
                    }
                }
            }
            
        }
        .onAppear {
            viewModel.getCompanies()
        }
    }
    
    
    private func deleteCategory(at offsets: IndexSet) {
        showingDeleteConfirmation = true
        itemPosition = offsets.first!
    }
}
