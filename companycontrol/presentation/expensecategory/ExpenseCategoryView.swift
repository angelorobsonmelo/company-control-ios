//
//  ExpenseCategoryView.swift
//  companycontrol
//
//  Created by Ângelo Melo on 17/05/2023.
//

import SwiftUI

struct ExpenseCategoryView: View {
    
    @ObservedObject var viewModel = DIContainer.shared.resolve(ExpenseCategoryViewModel.self)
    
    @State var categories:[ExpenseCategoryPresentation] = []
    
    @State private var snackBarMessage = ""
    @State private var snackBarType: SnackbarType = .error
    @State private var showSnackBar = false
    
    var body: some View {
        VStack {
            List(categories, id: \.id) { category in
                Text(category.name)
            }
            
            SnackbarView(message: snackBarMessage, snackbarType: snackBarType, isShowing: $showSnackBar)
                .frame(height: 40)
                .offset(y: 200)
        }
        .onAppear {
            viewModel.getCategories()
        }
        .onChange(of: viewModel.categoriesNetworkResult) { newValue in
            switch newValue {
            case .success(let categories):
                self.categories = categories
                break
            case .error(let message):
                snackBarMessage =  message ?? "Error"
                snackBarType = .error
                showSnackBar = true
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

struct ExpenseCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseCategoryView()
    }
}
