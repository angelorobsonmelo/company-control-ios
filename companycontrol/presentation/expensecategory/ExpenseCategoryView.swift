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
    @State private var showingDialog = false
    
    
    @State private var snackBarMessage = ""
    @State private var snackBarType: SnackbarType = .error
    @State private var showSnackBar = false
    @State private var showingDeleteConfirmation = false
    
    @State private var itemPosition: Int? = nil
    
    
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
                            print("Item tapped: \(category)")
                        }
                    }
                    .onDelete(perform: deleteCategory)
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.showingDialog = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear {
                viewModel.getCategories()
            }
            .sheet(isPresented: $showingDialog) {
                AddExpenseCategoryDialog(showingDialog: $showingDialog)
                    .environmentObject(viewModel)
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
