//
//  ExpenseViewModel.swift
//  companycontrol
//
//  Created by Ângelo Melo on 11/05/2023.
//

import Foundation
import Firebase

class ExpenseViewModel: ObservableObject {
    
    @Published var saveExpenseNetworkResult: NetworkResult<String> = .idle
    @Published var getExpensesNetworkResult: NetworkResult<[String: [ExpensePresentation]]> = .idle
    @Published var categories: [ExpenseCategoryPresentation] = []
    
    private let getExpensesUseCase: GetExpensesUseCase
    private let saveExpenseUseCase: SaveExpenseUseCase
    private let getExpenseCategoriesUseCase: GetExpenseCategoriesUseCase
    private let deleteExpenseUseCase: DeleteExpenseUseCase
    private let updateExpenseUseCase: UpdateExpenseUseCase
    
    private let auth: Auth
    
    @Published var expensesViews: [ExpensePresentation] = []
    
    var groupedCosts: [String: [ExpensePresentation]] {
        Dictionary(grouping: expensesViews) { cost in
            cost.date.formatStringDate(dateFormat: "dd/MM/yyyy", identifier: "pt-BR") ?? ""
        }
    }
    
    var sortedDates: [String] {
        groupedCosts.keys.sorted { date1, date2 in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateFormatter.locale = Locale(identifier: "pt-BR")
            guard let d1 = dateFormatter.date(from: date1),
                  let d2 = dateFormatter.date(from: date2) else {
                return false
            }
            return d1 > d2
        }
    }
    
    var totalAmount: Double {
        groupedCosts.values.flatMap { $0 }.reduce(0) { $0 + $1.amount }
    }
    
    
    init(
        getExpensesUseCase: GetExpensesUseCase,
        auth: Auth,
        saveExpenseUseCase: SaveExpenseUseCase,
        getExpenseCategoriesUseCase: GetExpenseCategoriesUseCase,
        deleteExpenseUseCase: DeleteExpenseUseCase,
        updateExpenseUseCase: UpdateExpenseUseCase
    ) {
        self.getExpensesUseCase = getExpensesUseCase
        self.auth = auth
        self.saveExpenseUseCase = saveExpenseUseCase
        self.getExpenseCategoriesUseCase = getExpenseCategoriesUseCase
        self.deleteExpenseUseCase = deleteExpenseUseCase
        self.updateExpenseUseCase = updateExpenseUseCase
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
                            self.saveExpenseNetworkResult = .success(Utils.generateCustomID())
                        case .failure(let error):
                            self.saveExpenseNetworkResult = .error(error.localizedDescription, Date())
                        }
                    }
                    
                }
                
            }
        }
        
    }
    
    func updateExpense(
        id: String,
        title: String,
        description: String,
        amount: String,
        expenseCategoryId: String,
        date: Date
    ) {
        DispatchQueue.global().async {
            if let email = self.auth.currentUser?.email {
                let amountDouble = amount.replacingOccurrences(of: "R$", with: "")
                
                let request = ExpenseRequest(
                    id: id,
                    title: title,
                    description: description,
                    userEmail: email,
                    amount: Double(amountDouble) ?? 0.0,
                    expenseCategoryId: expenseCategoryId,
                    date: date
                )
                
                self.updateExpenseUseCase.updateExpense(request: request) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success:
                            self.saveExpenseNetworkResult = .success(Utils.generateCustomID())
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
    
    func getExpenses(startDate: Date, endDate: Date) {
        DispatchQueue.global().async {
            if let email = self.auth.currentUser?.email {
                self.getExpensesUseCase.getAll(userEmail: email, startDate: startDate, endDate: endDate) { result in
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
                            
                            self.expensesViews = presentionModels
                            
                        case .failure(let error):
                            self.getExpensesNetworkResult = .error(error.localizedDescription, Date())
                        }
                    }
                }
            }
        }
    }
    
    func deleteExpense(at position: Int, from date: String) {
        let itemToDelte = groupedCosts[date]![position]
        
        DispatchQueue.global().async {
            self.deleteExpenseUseCase.delete(id: itemToDelte.id) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success: break
                        //                        self.networkResult = .success(true)
                    case .failure(let error): break
                        //                        self.networkResult = .error(error.localizedDescription, Date())
                    }
                }
            }
        }
    }
    
}
