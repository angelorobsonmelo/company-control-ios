//
//  AddExpenseCategoryDialog.swift
//  companycontrol
//
//  Created by Ângelo Melo on 17/05/2023.
//

import Foundation
import SwiftUI

struct AddCategoryView: View {
    
    @State private var showAlertDialog = false
    
    @State private var name: String = ""
    @Binding  var showingDialog: Bool
    @EnvironmentObject var viewModel: CategoryViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("NAME".localized + ":")) {
                        TextField("INSERT_NAME".localized, text: $name)
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
                                viewModel.save(name: name)
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
            .onChange(of: viewModel.networkResult) { newValue in
                switch newValue {
                case .success(let success):
                    showAlertDialog = true
                    self.name = ""
                    
                    break
                case .error(let message):
                    break
                case .loading:
                    break
                case .idle:
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
            .navigationBarTitle("ADD_CATEGORY".localized, displayMode: .inline)
        }
    }
    
    
}
