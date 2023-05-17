//
//  ExpenseViewModel.swift
//  companycontrol
//
//  Created by Ângelo Melo on 11/05/2023.
//

import Foundation
import Firebase

class ExpenseViewModel: ObservableObject {
    
    @Published var saveExpenseNetworkResult: NetworkResult<Bool> = .idle
    
    private let getExpensesUseCase: GetExpensesUseCase
    private let saveExpenseUseCase: SaveExpenseUseCase
    private let auth: Auth
    
    init(
        getExpensesUseCase: GetExpensesUseCase,
        auth: Auth,
        saveExpenseUseCase: SaveExpenseUseCase
    ) {
        self.getExpensesUseCase = getExpensesUseCase
        self.auth = auth
        self.saveExpenseUseCase = saveExpenseUseCase
    }
    
    func getExpenses() {
        DispatchQueue.global().async {
            
            
            
        }
    }
    
    func saveExpense(name: String) {
        DispatchQueue.global().async {
            let id = Utils.generateCustomID()
            if let email = self.auth.currentUser?.email {
                let request = ExpenseRequest(id: id, name: name, userEmail: email)
                
                self.saveExpenseUseCase.saveExpense(request: request) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success:
                            self.saveExpenseNetworkResult = .success(true)
                        case .failure(let error):
                            self.saveExpenseNetworkResult = .error(error.localizedDescription, Date())
                        }
                    }
                    
                }
                
            }
        }
        
    }
    
    func fetchData() {
        //            networkResult = .loading // Define o estado de loading
        //
        //            DispatchQueue.global().async {
        //                // Simulando uma requisição com atraso
        //                sleep(2)
        //
        //                DispatchQueue.main.async {
        //                    if Bool.random() {
        //                        // Simulando uma resposta bem-sucedida
        //                        self.networkResult = .success(User(name: "John Doe", email: "john@example.com"))
        //                    } else {
        //                        // Simulando uma resposta com erro
        //                        self.networkResult = .error("Erro na requisição")
        //                    }
        //                }
        //            }
    }
    
}
