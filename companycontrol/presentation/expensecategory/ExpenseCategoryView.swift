//
//  ExpenseCategoryView.swift
//  companycontrol
//
//  Created by Ângelo Melo on 17/05/2023.
//

import SwiftUI
import ICU

struct ExpenseCategoryView: View {
    
    @StateObject var viewModel = DIContainer.shared.resolve(ExpenseCategoryViewModel.self)
    
    @State var categories:[ExpenseCategoryPresentation] = []
    @State private var showingAddDialog = false
    @State private var showingEditDialog = false
    
    @State private var showingDeleteConfirmation = false
    
    @State private var itemPosition: Int? = nil
    @State private var selectedCategory: ExpenseCategoryPresentation? = nil

    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(categories, id: \.id) { category in
                        HStack {
                            Text(category.name)
                            Spacer() // This will push the Text to the left
                        }
                        .contentShape(Rectangle())
                        .background(Color.clear) // This will make the entire HStack tappable
                        .onTapGesture {
                            selectedCategory = category
                            showingEditDialog = true
                        }
                    }
                    .onDelete(perform: deleteCategory)
                }
                
            }
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
                viewModel.getCategories()
            }
            .sheet(isPresented: $showingAddDialog) {
                AddExpenseCategoryView(showingDialog: $showingAddDialog)
                    .environmentObject(viewModel)
            }
            .sheet(isPresented: $showingEditDialog) {
                EditExpenseCategoryView(category: self.selectedCategory!, showingDialog: $showingEditDialog)
                    .environmentObject(viewModel)
            }
            .onChange(of: selectedCategory) { newCategory in
                if let newCategory = newCategory {
                        self.selectedCategory = newCategory
                        self.showingEditDialog = true
                    }
            }
            .onChange(of: viewModel.categoriesNetworkResult) { newValue in
                switch newValue {
                case .success(let categories):
                    self.categories = categories
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
        .alert(isPresented: $showingDeleteConfirmation) {
            Alert(
                title: Text("Delete Category"),
                message: Text("Are you sure you want to delete this category?"),
                primaryButton: .destructive(Text("Delete")) {
                    viewModel.remove(id: self.categories[itemPosition!].id)
                },
                secondaryButton: .cancel {
                    
                }
            )
        }
        .navigationBarTitle("Expense Categories", displayMode: .inline)
    }
    
    private func deleteCategory(at offsets: IndexSet) {
        showingDeleteConfirmation = true
        itemPosition = offsets.first!
    }
}



//struct ExpenseCategoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExpenseCategoryView()
//    }
//}
