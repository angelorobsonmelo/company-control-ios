//
//  AddExpenseCategoryDialog.swift
//  companycontrol
//
//  Created by Ângelo Melo on 17/05/2023.
//

import Foundation
import SwiftUI

struct AddCompanyView: View {
    
    @State private var showAlertDialog = false
    
    @State private var name: String = ""
    @State private var address: String = ""
    @State private var contactNumber: String = ""
    @Binding  var showingDialog: Bool
    @EnvironmentObject var viewModel: CompanyViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    VStack(alignment: .leading) {
                        Text("Name:")
                        TextField("", text: $name)
                            .keyboardType(.default)
                            .textContentType(.oneTimeCode)
                            .toolbar {
                                ToolbarItem(placement: .keyboard) {
                                    HStack {
                                        Spacer()
                                        Button("Done") {
                                            hideKeyboard()
                                        }
                                    }
                                }
                            }
                    }
                    .onTapGesture {
                        hideKeyboard()
                    }
                    
                    VStack(alignment: .leading)  {
                        Text("Address:")
                        
                        TextEditor(text: $address)
                            .frame(height: 80)
                            .padding(10)
                    }
                    .onTapGesture {
                        hideKeyboard()
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Contact Number:")
                        TextField("", text: $contactNumber)
                            .keyboardType(.default)
                            .textContentType(.oneTimeCode)
                            .toolbar {
                                ToolbarItem(placement: .keyboard) {
                                    HStack {
                                        Spacer()
                                        Button("Done") {
                                            hideKeyboard()
                                        }
                                    }
                                }
                            }
                    }
                    .onTapGesture {
                        hideKeyboard()
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
                                viewModel.save(
                                    name: name,
                                    address: address,
                                    contactNumber: contactNumber)
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
                
            }
            .onChange(of: viewModel.networkResult) { newValue in
                switch newValue {
                case .success(let success):
                    showAlertDialog = true
                    self.name = ""
                    print("successfully")
                    
                    break
                case .error(let message):
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
                    title: Text("Save Successfully"),
                    message: Text(""),
                    dismissButton: .default(Text("OK"))
                )
            }
            .navigationBarTitle("Add Company", displayMode: .inline)
        }
        
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    
}
