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
    
    private let getExpenseUseCase: GetExpenseCategoriesUseCase
    private let auth: Auth
    
    init(
        getExpenseUseCase: GetExpenseCategoriesUseCase,
        auth: Auth
    ) {
        self.getExpenseUseCase = getExpenseUseCase
        self.auth = auth
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
                            self.categoriesNetworkResult = .error(error.localizedDescription)
                        }
                    }
                }
                
            }
        }
    }
    
    
}
