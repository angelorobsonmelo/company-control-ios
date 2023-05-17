//
//  ExpemseCategoryViewModel.swift
//  companycontrol
//
//  Created by Ângelo Melo on 17/05/2023.
//

import Foundation
import Firebase

class ExpenseCategoryViewModel: ObservableObject {
    
    @Published var categoriesNetworkResult: NetworkResult<[ExpenseCategoryPresentation]> = .idle
    @Published var saveCategoryNetworkResult: NetworkResult<Bool> = .idle
    
    private let getExpenseUseCase: GetExpenseCategoriesUseCase
    private let saveCategoryUseCase: SaveExpenseCategoryUseCase
    private let auth: Auth
    
    init(
        getExpenseUseCase: GetExpenseCategoriesUseCase,
        auth: Auth,
        saveCategoryUseCase: SaveExpenseCategoryUseCase
    ) {
        self.getExpenseUseCase = getExpenseUseCase
        self.auth = auth
        self.saveCategoryUseCase = saveCategoryUseCase
    }
    
    func getCategories()  {
        categoriesNetworkResult = .loading
        
        DispatchQueue.global().async {
            if let email = self.auth.currentUser?.email {
                self.getExpenseUseCase.getAll(userEmail:email) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let categoriesResponse):
                            let categories = categoriesResponse.map { item in
                                ExpenseCategoryPresentation(id: item.id, name: item.name)
                            }
                            
                            self.categoriesNetworkResult = .success(categories)
                        case .failure(let error):
                            self.categoriesNetworkResult = .error(error.localizedDescription, Date())
                        }
                    }
                }
            }
        }
    }
    
    func save(name: String) {
        saveCategoryNetworkResult = .loading

        DispatchQueue.global().async {
            if let email = self.auth.currentUser?.email {
                let id = Utils.generateCustomID()
                let request = ExpenseCategoryRequest(id: id, name: name, userEmail: email)
                
                self.saveCategoryUseCase.saveCategory(request: request) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success:
                            self.saveCategoryNetworkResult = .success(true)
                        case .failure(let error):
                            self.saveCategoryNetworkResult = .error(error.localizedDescription, Date())
                        }
                    }
                }
                
            }
        }
    }
    
    
}
