//
//  AddExpenseView.swift
//  companycontrol
//
//  Created by Ângelo Melo on 20/05/2023.
//

import Foundation
import SwiftUI



struct EditExpenseView: View {
    
    @Binding var showingDialog: Bool
    @EnvironmentObject var viewModel: ExpenseViewModel
    
    var expense: ExpensePresentation
    let callback: () -> Void
    
    @State private var showAlertDialog = false
    @State private var isComingFromCategoryScreen = false
    
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
    
   
    let formatter: NumberFormatter = CurrencyFormatter()
    
    @State private var selectedOption: String? = ""
    
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    VStack(alignment: .leading) {
                        Text("TITLE".localized + ":")
                        TextField("", text: $title)
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
                    
                    VStack(alignment: .leading)  {
                        Text("DESCRIPTION".localized + ":")
                        
                        TextEditor(text: $description)
                            .frame(height: 80)
                            .padding(10)
                    }
                    .onTapGesture {
                        hideKeyboard()
                    }
                    
                    VStack(alignment: .leading) {
                        Text("VALUE".localized + ":")
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
                        
                    }
                    .onTapGesture {
                        hideKeyboard()
                    }
                    
                    VStack(alignment: .leading) {
                        let options = viewModel.categories.compactMap { item in
                            item.name
                        }
                        
                        
                        Text("CATEGORY".localized + ":")
                        NavigationLink(destination: OptionsView(selectedOption: $selectedOption, options: options)) {
                            
                            HStack {
                                Text(selectedOption ?? "Select an option")
                                    .keyboardType(.default)
                                    .textContentType(.oneTimeCode)
                            }
                            .onTapGesture {
                                self.hideKeyboard()
                            }
                        }
                    }
                    
                    DateSelectionView(label: "DATE".localized + ":", date: $date)
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
                                viewModel.updateExpense(
                                    id: expense.id,
                                    title: title,
                                    description: description,
                                    amount: amount,
                                    expenseCategoryId: categiroryId,
                                    date: date)
                                
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
                .onAppear {
                    viewModel.getCategories()
                    if isComingFromCategoryScreen {
                        isComingFromCategoryScreen = false
                        return
                    }
                    
                    self.title = expense.title
                    self.description = expense.description
                    self.amount = formatter.string(from: NSNumber(value: expense.amount)) ?? ""
                    self.selectedOption = expense.expenseCategory.name
                    self.categiroryId = expense.expenseCategory.id
                    self.date = expense.date.toDate()
                }
                .padding()
                .onChange(of: viewModel.saveExpenseNetworkResult) { newValue in
                    switch newValue {
                    case .success(_):
                        
                        alertTitle = "SAVE_SUCCESSFULLY".localized
                               alertMessage = ""
                        alertDismissButton = .default(Text("OK".localized)) {
                                   callback()
                               }
                        
                        showAlert = true

                        break
                    case .error(let message):
                        print("error: \(message)")
                        alertTitle = message.0
                                alertMessage = ""
                        alertDismissButton = .default(Text("OK".localized))
                                showAlert = true
                        break
                    case .loading:
                        print("Loading")
                        break
                    case .idle:
                        print("Idle")
                        break
                    }
                }
                .onChange(of: selectedOption) { newValue in
                    if let optionSelected = newValue {
                        let itemSelected = self.viewModel.categories.first { item in
                            item.name == optionSelected
                        }
                        
                        self.categiroryId = itemSelected?.id ?? ""
                        self.selectedOption = optionSelected
                        // recuperar id aqui
                        isComingFromCategoryScreen = true
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    dismissButton: alertDismissButton
                )
            }
            .navigationBarTitle("EDIT_EXPENSIVE".localized, displayMode: .inline)
        }
        
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private var placeholderView: some View {
        if description.isEmpty {
            return AnyView(Text("DESCRIPTION".localized)
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
    

}


//struct EditExpenseView_Previews: PreviewProvider {
//
//    @State static var showingDialog = true
//
//    static var previews: some View {
//
//        EditExpenseView(showingDialog: $showingDialog, expense: ExpensePresentation.oneInstance()) {
//
//        }
//    }
//}
