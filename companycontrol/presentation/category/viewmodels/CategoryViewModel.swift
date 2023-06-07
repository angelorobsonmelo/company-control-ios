//
//  ExpemseCategoryViewModel.swift
//  companycontrol
//
//  Created by Ângelo Melo on 17/05/2023.
//

import Foundation
import Firebase

class CategoryViewModel: ObservableObject {
    
    @Published var categoriesNetworkResult: NetworkResult<[CategoryViewData]> = .idle
    @Published var networkResult: NetworkResult<Bool> = .idle
    
    private let getExpenseUseCase: GetCategoriesUseCase
    private let saveCategoryUseCase: SaveCategoryUseCase
    private let deleteCategoryUseCase: DeleteCategoryUseCase
    private let updateCategoryUseCase: UpdateCategoryUseCase
    private let auth: Auth
    
    init(
        getExpenseUseCase: GetCategoriesUseCase,
        auth: Auth,
        saveCategoryUseCase: SaveCategoryUseCase,
        deleteCategoryUseCase: DeleteCategoryUseCase,
        updateCategoryUseCase: UpdateCategoryUseCase
    ) {
        self.getExpenseUseCase = getExpenseUseCase
        self.auth = auth
        self.saveCategoryUseCase = saveCategoryUseCase
        self.deleteCategoryUseCase = deleteCategoryUseCase
        self.updateCategoryUseCase = updateCategoryUseCase
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
                                CategoryViewData(id: item.id, name: item.name)
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
        networkResult = .loading
        
        DispatchQueue.global().async {
            if let email = self.auth.currentUser?.email {
                let id = Utils.generateCustomID()
                let request = CategoryRequest(id: id, name: name, userEmail: email)
                
                self.saveCategoryUseCase.saveCategory(request: request) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success:
                            self.networkResult = .success(true)
                        case .failure(let error):
                            self.networkResult = .error(error.localizedDescription, Date())
                        }
                    }
                }
                
            }
        }
    }
    
    func remove(id: String) {
        networkResult = .loading
        
        DispatchQueue.global().async {
            self.deleteCategoryUseCase.delete(id: id) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self.networkResult = .success(true)
                    case .failure(let error):
                        self.networkResult = .error(error.localizedDescription, Date())
                    }
                }
            }
        }
    }
    
    func update(presentionModel: CategoryViewData) {
        if let email = self.auth.currentUser?.email {
        networkResult = .loading
        
        let request = CategoryRequest(id: presentionModel.id, name: presentionModel.name, userEmail: email)
        
            DispatchQueue.global().async {
                self.updateCategoryUseCase.update(request: request) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success:
                            self.networkResult = .success(true)
                        case .failure(let error):
                            self.networkResult = .error(error.localizedDescription, Date())
                        }
                    }
                }
            }
        }
    }
    
    
}
