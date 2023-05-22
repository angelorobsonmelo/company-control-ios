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
    @Published var categories: [ExpenseCategoryPresentation] = []
    
    private let getExpensesUseCase: GetExpensesUseCase
    private let saveExpenseUseCase: SaveExpenseUseCase
    private let getExpenseCategoriesUseCase: GetExpenseCategoriesUseCase

    private let auth: Auth
    
    init(
        getExpensesUseCase: GetExpensesUseCase,
        auth: Auth,
        saveExpenseUseCase: SaveExpenseUseCase,
        getExpenseCategoriesUseCase: GetExpenseCategoriesUseCase
    ) {
        self.getExpensesUseCase = getExpensesUseCase
        self.auth = auth
        self.saveExpenseUseCase = saveExpenseUseCase
        self.getExpenseCategoriesUseCase = getExpenseCategoriesUseCase
    }
    
    func getExpenses() {
        DispatchQueue.global().async {
            
        }
    }
    
    func saveExpense(
        title: String,
        description: String,
        amount: Double,
        expenseCategoryId: String,
        date: Date
    ) {
        DispatchQueue.global().async {
            let id = Utils.generateCustomID()
            if let email = self.auth.currentUser?.email {
                let request = ExpenseRequest(
                    id: id,
                    title: title,
                    description: description,
                    userEmail: email,
                    amount: amount,
                    expenseCategoryId: expenseCategoryId,
                    date: date
                )
                
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
    
    func getCategories()  {
        DispatchQueue.global().async {
            if let email = self.auth.currentUser?.email {
                self.getExpenseCategoriesUseCase.getAll(userEmail:email) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let categoriesResponse):
                            let categories = categoriesResponse.map { item in
                                ExpenseCategoryPresentation(id: item.id, name: item.name)
                            }
                            
                            self.categories = categories
                        case .failure(let error):
                            print(error)
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
