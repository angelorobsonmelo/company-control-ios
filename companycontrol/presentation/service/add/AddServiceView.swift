//
//  AddExpenseView.swift
//  companycontrol
//
//  Created by Ângelo Melo on 20/05/2023.
//

import Foundation
import SwiftUI



struct AddServiceView: View {
    
    @Binding var showingDialog: Bool
    @EnvironmentObject var viewModel: ServiceViewModel
    let callback: () -> Void
    
    @State private var showAlertDialog = false
    
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var alertDismissButton = Alert.Button.default(Text("OK"))
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var date = Date()
    @State private var amount = ""
    @State private var numericValue: Double = 0.0
    @State private var categiroryId: String = ""
    @State private var companyId: String = ""

    
    
    let formatter: NumberFormatter = CurrencyFormatter()
    
    @State private var selectedOption: String? = nil
    @State private var selectedCompanyOption: String? = nil
    
    @State private var name: String = ""
    @State private var email: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                let options = viewModel.categories.compactMap { item in
                    item.name
                }
                
                TextField("Title", text: $title)
                    .keyboardType(.default)
                    .textContentType(.oneTimeCode)
                
                
                TextEditor(text: $description)
                    .frame(height: 80)
                    .padding(10)
                    .overlay(
                        VStack(alignment: .leading) {
                            if description.isEmpty {
                                Text("Description")
                                    .foregroundColor(Color.gray)
                                    .padding(.leading, 5)
                            }
                            Spacer()
                        }.padding(.top, 8)
                    )

                
                TextField("0,00", text: $amount)
                    .keyboardType(.decimalPad)
                    .padding()
                    .onChange(of: amount, perform: { value in
                        let digits = value.filter { "0123456789".contains($0) }
                        let number = Double(digits) ?? 0.0
                        let newAmount = number / 100
                        amount = formatter.string(from: NSNumber(value: newAmount)) ?? ""
                        numericValue = newAmount
                        
                    })
                    .onAppear() {
                        amount = amount.isEmpty ? formatter.string(from: NSNumber(value: 0)) ?? "" : amount
                    }
                
                NavigationLink(destination: OptionsView(selectedOption: $selectedOption, options: options)) {
                    
                    HStack {
                        Text(selectedOption ?? "Select a category")
                            .keyboardType(.default)
                            .textContentType(.oneTimeCode)
                    }
                    .onTapGesture {
                        self.hideKeyboard()
                    }
                }
                
                NavigationLink(destination: OptionsView(selectedOption: $selectedCompanyOption, options: viewModel.companies.compactMap { item in
                    item.name
                })) {
                    
                    HStack {
                        Text(selectedCompanyOption ?? "Select a company")
                            .keyboardType(.default)
                            .textContentType(.oneTimeCode)
                    }
                    .onTapGesture {
                        self.hideKeyboard()
                    }
                }
                
                
                DateSelectionView(label: "Date:", date: $date)
                    .onTapGesture {
                        hideKeyboard()
                    }
                
            }
            .onAppear {
                viewModel.getCategories()
                viewModel.getCompanies()
            }
            .navigationBarTitle("Add Service", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.save(
                            title: title,
                            description: description,
                            amount: numericValue,
                            expenseCategoryId: categiroryId,
                            companyId: companyId,
                            date: date)
                    }) {
                        Image(systemName: "checkmark")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showingDialog = false
                    }) {
                        Image(systemName: "xmark")
                        
                    }
                }
            }
            .onChange(of: selectedOption) { newValue in
                if let optionSelected = newValue {
                    let itemSelected = self.viewModel.categories.first { item in
                        item.name == optionSelected
                    }
                    
                    self.categiroryId = itemSelected?.id ?? ""
                    // recuperar id aqui
                }
            }
            .onChange(of: selectedCompanyOption) { newValue in
                if let optionSelected = newValue {
                    let itemSelected = self.viewModel.companies.first { item in
                        item.name == optionSelected
                    }
                    
                    self.companyId = itemSelected?.id ?? ""
                    // recuperar id aqui
                }
            }
            .onChange(of: viewModel.isSaved) { isCompanySaved in
                if isCompanySaved {
                    resetFields()
                    viewModel.isSaved = false // para reiniciar o ciclo
                }
            }
            .alert(isPresented: $viewModel.showAlertDialog) {
                 Alert(
                    title: Text(viewModel.dialogMessage),
                    message: Text(""),
                    dismissButton: .default(Text("OK"))
                )
            }
            
        }
}

func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}

private var placeholderView: some View {
    if description.isEmpty {
        return AnyView(Text("Description")
            .foregroundColor(.gray)
            .padding(.top, 8)
            .padding(.leading, 5))
    } else {
        return AnyView(EmptyView())
    }
}

struct DateSelectionView: View {
    var label: String
    @Binding var date: Date
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
            
            DatePicker("", selection: $date, displayedComponents: .date)
                .labelsHidden()
        }
    }
}

func resetFields() {
    self.title  = ""
    self.description = ""
    self.date = Date()
    self.amount = ""
    self.numericValue = 0.0
    self.categiroryId = ""
    self.selectedOption = ""
    self.selectedCompanyOption = ""
    self.companyId = ""
}
}


