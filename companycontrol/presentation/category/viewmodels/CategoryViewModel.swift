//
//  ExpemseCategoryViewModel.swift
//  companycontrol
//
//  Created by Ângelo Melo on 17/05/2023.
//

import Foundation
import Firebase
import Combine

class CategoryViewModel: ObservableObject {
    
    @Published var categoriesNetworkResult: NetworkResult<[CategoryViewData]> = .idle
    @Published var networkResult: NetworkResult<Bool> = .idle
    
    private let getExpenseUseCase: GetCategoriesUseCase
    private let saveCategoryUseCase: SaveCategoryUseCase
    private let deleteCategoryUseCase: DeleteCategoryUseCase
    private let updateCategoryUseCase: UpdateCategoryUseCase
    private let auth: Auth
    
    private var cancellables: Set<AnyCancellable> = []

    
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
        if let email = self.auth.currentUser?.email {
            getExpenseUseCase.execute(userEmail: email)
                .subscribe(on: DispatchQueue.global())
                .receive(on: DispatchQueue.main)
                .map {
                    $0.map { item in
                        CategoryViewData(id: item.id, name: item.name)
                    }
                }
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        break
                    case .finished:
                        break
                    }
                    
                } receiveValue: { categories in
                    self.categoriesNetworkResult = .success(categories)                }
                .store(in: &cancellables)
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
