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
    @Published var getExpensesNetworkResult: NetworkResult<[ExpensePresentation]> = .idle
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
    
    func getExpenses() {
        DispatchQueue.global().async {
            if let email = self.auth.currentUser?.email {
                self.getExpensesUseCase.getAll(userEmail: email) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let items):
                            let presentionModels = items.map { item in
                                ExpensePresentation(
                                    id: item.id,
                                    title: item.title,
                                    description: item.description,
                                    userEmail: item.userEmail,
                                    amount: item.amount,
                                    date: item.date,
                                    expenseCategory: ExpenseCategoryPresentation(
                                        id: item.expenseCategory.id,
                                        name: item.expenseCategory.name))
                            }
                            
                            self.getExpensesNetworkResult = .success(presentionModels)
                            
                        case .failure(let error):
                            self.getExpensesNetworkResult = .error(error.localizedDescription, Date())
                        }
                    }
                }
            }
        }
    }
    
}
