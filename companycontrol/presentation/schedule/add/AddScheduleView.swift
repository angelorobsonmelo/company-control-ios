//
//  AddScheduleView.swift
//  companycontrol
//
//  Created by Ângelo Melo on 31/07/2023.
//

import Foundation
import SwiftUI



struct AddScheduleView: View {
    
    @Binding var showingDialog: Bool
    @EnvironmentObject var viewModel: ScheduleViewModel
    let callback: () -> Void
    
    @State private var showAlertDialog = false
    @State private var isOn = false

    
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
                TextField("TITLE".localized, text: $title)
                    .keyboardType(.default)
                    .textContentType(.oneTimeCode)
                
                
                TextEditor(text: $description)
                    .frame(height: 80)
                    .padding(10)
                    .overlay(
                        VStack(alignment: .leading) {
                            if description.isEmpty {
                                Text("DESCRIPTION".localized)
                                    .foregroundColor(Color.gray)
                                    .padding(.leading, 5)
                            }
                            Spacer()
                        }.padding(.top, 8)
                    )
                
                Toggle(isOn: $isOn) {
                    Text("Completed")
                }
                
                
                DateSelectionView(label: "DATE".localized + ":", date: $date)
                    .onTapGesture {
                        hideKeyboard()
                    }
                
            }
           
            .navigationBarTitle("ADD_SCHEDULE".localized, displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.save(
                            title: title,
                            description: description,
                            date: date,
                            completed: isOn
                        )
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
                    dismissButton: .default(Text("OK".localized))
                )
            }
            
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
