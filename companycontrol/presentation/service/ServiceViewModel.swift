//
//  ServiceViewModel.swift
//  companycontrol
//
//  Created by Ângelo Melo on 23/06/2023.
//

import Foundation
import Combine
import Firebase

class ServiceViewModel: ObservableObject {
    
    private let saveUseCase: SaveServiceUseCase
    private let getCategoriesUseCase: GetCategoriesUseCase
    private let getCompaniesUseCase: GetCompaniesUseCase
    private let auth: Auth
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var saveExpenseNetworkResult: NetworkResult<String> = .idle
    @Published var getExpensesNetworkResult: NetworkResult<[String: [ExpensePresentation]]> = .idle
    
    @Published var showAlertDialog = false
    @Published var dialogMessage = ""
    @Published var isSaved = false
    @Published var categories: [CategoryViewData] = []
    @Published var companies: [CompanyViewData] = []

    
    init(saveUseCase: SaveServiceUseCase,
         auth: Auth,
         getCategoriesUseCase: GetCategoriesUseCase,
         getCompaniesUseCase: GetCompaniesUseCase
    ) {
        self.saveUseCase = saveUseCase
        self.auth = auth
        self.getCategoriesUseCase = getCategoriesUseCase
        self.getCompaniesUseCase = getCompaniesUseCase
    }
    
    
    func save(
        title: String,
        description: String,
        amount: Double,
        expenseCategoryId: String,
        companyId: String,
        date: Date
    ) {
        if let email = self.auth.currentUser?.email {
            let request = ServiceRequest(
                id: Utils.generateCustomID(),
                title: title,
                description: description,
                userEmail: email,
                amount: amount,
                categoryId: expenseCategoryId,
                companyId: companyId,
                date: date
            )
            
           
            self.saveUseCase.execute(request: request)
                .subscribe(on: DispatchQueue.global())
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        switch error {
                        case let validationError as ValidationFormEnum:
                            switch validationError {
                            case .emptyField(let reason):
                                print("Empty field error: \(reason)")
                                self.showAlertDialog = true
                                self.dialogMessage = reason
                            }
                        default:
                            print("Unknown error: \(error)")
                        }
                        
                    case .finished:
                        self.showAlertDialog = true
                        self.dialogMessage = "Save Successfully"
                        self.isSaved = true
                    }
                } receiveValue: { _ in
                    
                }
                .store(in: &cancellables)

            
        }
    }
    
    func getCategories()  {
        if let email = self.auth.currentUser?.email {
            getCategoriesUseCase.execute(userEmail: email)
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
                    self.categories = categories
                }
                .store(in: &cancellables)
        }
    }
    
    func getCompanies() {
        if let email = self.auth.currentUser?.email {
            self.getCompaniesUseCase.execute(userEmail: email)
                .subscribe(on: DispatchQueue.global())
                .receive(on: DispatchQueue.main)
                .map {
                    $0.map { item in
                        CompanyViewData(id: item.id, address: item.address, contactNumber: item.contactNumber, name: item.name, userEmail: email)
                    }
                }
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        break
                    case .finished:
                        break
                    }
                } receiveValue: { companyViewData in
                    self.companies = companyViewData
                }
                .store(in: &cancellables)
        }
    }
    
    
}
