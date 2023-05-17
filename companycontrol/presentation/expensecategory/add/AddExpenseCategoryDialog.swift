//
//  AddExpenseCategoryDialog.swift
//  companycontrol
//
//  Created by Ângelo Melo on 17/05/2023.
//

import Foundation
import SwiftUI

struct AddExpenseCategoryDialog: View {
    
    @State private var snackBarMessage = ""
    @State private var snackBarType: SnackbarType = .error
    @State private var showSnackBar = false
    
    
    @State private var name: String = ""
    @Binding  var showingDialog: Bool
    @EnvironmentObject var viewModel2: ExpenseCategoryViewModel


    
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
                                viewModel2.save(name: name)
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
                
                SnackbarView(message: snackBarMessage, snackbarType: snackBarType, isShowing: $showSnackBar)
                    .frame(height: 40)
                    .offset(y: 200)
            }
            .onChange(of: viewModel2.saveCategoryNetworkResult) { newValue in
                switch newValue {
                case .success(let success):
                    snackBarMessage =  "Register Successfully"
                    snackBarType = .success
                    showSnackBar = true
                    self.name = ""
                    print("successfully")
                    
                    break
                case .error(let message):
                    snackBarMessage =  message.0 ?? "Error"
                    snackBarType = .error
                    showSnackBar = true
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
            .navigationBarTitle("Add Category", displayMode: .inline)
        }
    }
    
    
}
