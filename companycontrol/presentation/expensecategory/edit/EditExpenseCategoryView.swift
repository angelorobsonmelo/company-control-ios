//
//  AddExpenseCategoryDialog.swift
//  companycontrol
//
//  Created by Ângelo Melo on 17/05/2023.
//

import Foundation
import SwiftUI

struct EditExpenseCategoryView: View {
    
    var category: ExpenseCategoryPresentation
    
    @State private var showAlertDialog = false
    @State private var name: String = ""
    
    @Binding  var showingDialog: Bool
    
    @EnvironmentObject var viewModel: ExpenseCategoryViewModel
    
    
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Category Name:")) {
                        TextField("Insert category name", text: $name)
                    }
                    
                    Section {
                        HStack {
                            Button(action: {
                                showingDialog = false
                            }, label: {
                                Text("Cancel")
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            })
                            .buttonStyle(PlainButtonStyle())
                            
                            Button(action: {
                                category.name = self.name
                                    viewModel.update(presentionModel: category)
                            }, label: {
                                Text("Save")
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
                self.name = category.name
                
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
                    title: Text("Updated Successfully"),
                    message: Text(""),
                    dismissButton: .default(Text("OK"))
                )
            }
            .navigationBarTitle("Update Category", displayMode: .inline)
        }
    }
    
    
}
