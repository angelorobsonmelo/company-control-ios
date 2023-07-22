//
//  AddExpenseCategoryDialog.swift
//  companycontrol
//
//  Created by Ângelo Melo on 17/05/2023.
//

import Foundation
import SwiftUI

struct EditCompanyView: View {
    
    var company: CompanyViewData

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
                        Text("NAME".localized + ":")
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
                        Text("ADRESS".localized + ":")
                        
                        TextEditor(text: $address)
                            .frame(height: 80)
                            .padding(10)
                    }
                    .onTapGesture {
                        hideKeyboard()
                    }
                    
                    VStack(alignment: .leading) {
                        Text("CONTACT_NUMBER".localized + ":")
                        TextField("", text: $contactNumber)
                            .keyboardType(.default)
                            .textContentType(.oneTimeCode)
                            .toolbar {
                                ToolbarItem(placement: .keyboard) {
                                    HStack {
                                        Spacer()
                                        Button("DONE".localized) {
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
                                viewModel.update(
                                    id: company.id,
                                    name: name,
                                    address: address,
                                    contactNumber: contactNumber)
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
                
            }
            .onAppear {
                self.name = company.name
                self.address = company.address
                self.contactNumber = company.contactNumber
            }
            .alert(isPresented: $viewModel.showAlertDialog) {
                 Alert(
                    title: Text(viewModel.dialogMessage),
                    message: Text(""),
                    dismissButton: .default(Text("OK".localized))
                )
            }
            .onChange(of: viewModel.isCompanySaved) { isCompanySaved in
                if isCompanySaved {
                    viewModel.isCompanySaved = false // para reiniciar o ciclo
                }
            }
            .navigationBarTitle("EDIT_COMPANY".localized, displayMode: .inline)
        }
        
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    
}
