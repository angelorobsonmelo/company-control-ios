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
                            HStack {
                                Text(company.name)
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .background(Color.clear)
                            .onTapGesture {
                                selectedCompany = company
                                showingEditDialog = true
                            }
                        }
                        .onDelete(perform: deleteCategory)
                    }
                    
                }
                .navigationBarTitle("Companies", displayMode: .inline)
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
                .sheet(isPresented: $showingEditDialog) {
                    //                EditCategoryView(
                    //                    category: self.selectedCompany!,
                    //                    showingDialog: $showingEditDialog)
                    //                .environmentObject(viewModel)
                }
                //            .onChange(of: selectedCompany) { newCategory in
                //                if let newCategory = newCategory {
                //                    self.selectedCategory = newCategory
                //                    self.showingEditDialog = true
                //                }
                //            }
                .onChange(of: viewModel.getCompaniesNetworkResult) { newValue in
                    switch newValue {
                    case .success(let companies):
                        //                        self.companies = companies
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
