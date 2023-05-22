//
//  AddExpenseView.swift
//  companycontrol
//
//  Created by Ângelo Melo on 20/05/2023.
//

import Foundation
import SwiftUI



struct AddExpenseView: View {
    
    @Binding  var showingDialog: Bool
    @EnvironmentObject var viewModel: ExpenseViewModel
    
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var nextDueDate = Date()
    @State private var amount = ""
    @State private var numericValue: Double = 0.0
    
    
    let formatter: NumberFormatter = CurrencyFormatter()
    
    @State private var selectedOption: String? = ""
    let options = ["Option 1", "Option 2", "Option 3"]
    
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    VStack(alignment: .leading) {
                        Text("title:")
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
                        Text("Description:")
                        
                        TextEditor(text: $description)
                            .frame(height: 80)
                            .padding(10)
                    }
                    .onTapGesture {
                        hideKeyboard()
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Value:")
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
                                amount = formatter.string(from: NSNumber(value: 0)) ?? "0,00"
                            }
                        
                    }
                    .onTapGesture {
                        hideKeyboard()
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Category:")
                        
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
                    
                    DateSelectionView(label: "Date:", date: $nextDueDate)
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
                                //                                viewModel.save(name: name)
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
            
            //            .onChange(of: viewModel.networkResult) { newValue in
            //                switch newValue {
            //                case .success(let success):
            //                    showAlertDialog = true
            //                    self.name = ""
            //                    print("successfully")
            //
            //                    break
            //                case .error(let message):
            //                    print("error: \(message)")
            //                    break
            //                case .loading:
            //                    print("Loading")
            //                    break
            //                case .idle:
            //                    print("Idle")
            //                    break
            //                }
            //            }
            //            .alert(isPresented: $showAlertDialog) {
            //                Alert(
            //                    title: Text("Save Successfully"),
            //                    message: Text(""),
            //                    dismissButton: .default(Text("OK"))
            //                )
            //            }
            .navigationBarTitle("Add Expense", displayMode: .inline)
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
}

struct LoginView_Previews: PreviewProvider {
    
    @State static var showingDialog = true
    
    static var previews: some View {
        
        AddExpenseView(showingDialog: self.$showingDialog)
    }
}
