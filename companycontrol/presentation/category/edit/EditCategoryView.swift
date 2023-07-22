//
//  AddExpenseCategoryDialog.swift
//  companycontrol
//
//  Created by Ângelo Melo on 17/05/2023.
//

import Foundation
import SwiftUI

struct EditCategoryView: View {
    
    var category: CategoryViewData
    
    @State private var showAlertDialog = false
    @State private var fieldName: String = ""
    
    @Binding  var showingDialog: Bool
    
    @EnvironmentObject var viewModel: CategoryViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("NAME".localized + ":")) {
                        TextField("INSERT_NAME".localized, text: $fieldName)
                    }
                    
                    Section {
                        HStack {
                            Button(action: {
                                showingDialog = false
                            }, label: {
                                Text("CANCEL".localized)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            })
                            .buttonStyle(PlainButtonStyle())
                            
                            Button(action: {
                                category.name = self.fieldName
                                viewModel.update(presentionModel: category)
                            }, label: {
                                Text("SAVE".localized)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            })
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .padding()
            }
            .onAppear {
                self.fieldName = category.name
            }
            .onChange(of: viewModel.networkResult) { newValue in
                switch newValue {
                case .success(let success):
                    showAlertDialog = true
                    break
                case .error(let message):
                    showAlertDialog = true
                    print("error: \(message)")
                    break
                case .loading:
                    print("Loading")
                    break
                case .idle:
                    print("Idle")
                    break
                }
            }
            .alert(isPresented: $showAlertDialog) {
                Alert(
                    title: Text("SAVE_SUCCESSFULLY".localized),
                    message: Text(""),
                    dismissButton: .default(Text("OK".localized))
                )
            }
            .navigationBarTitle("UPDATE_CATEGORY".localized, displayMode: .inline)
        }
    }
    
    
}
