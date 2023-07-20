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
    private let getAllServiceUseCase: GetAllServiceUseCase
    private let deleteServiceUseCase: DeleteServiceUseCase
    private let editServiceUseCase: EditServiceUseCase
    private let auth: Auth
    
    init(saveUseCase: SaveServiceUseCase,
         auth: Auth,
         getCategoriesUseCase: GetCategoriesUseCase,
         getCompaniesUseCase: GetCompaniesUseCase,
         getAllServiceUseCase: GetAllServiceUseCase,
         deleteServiceUseCase: DeleteServiceUseCase,
         editServiceUseCase: EditServiceUseCase
    ) {
        self.saveUseCase = saveUseCase
        self.auth = auth
        self.getCategoriesUseCase = getCategoriesUseCase
        self.getCompaniesUseCase = getCompaniesUseCase
        self.getAllServiceUseCase = getAllServiceUseCase
        self.deleteServiceUseCase = deleteServiceUseCase
        self.editServiceUseCase = editServiceUseCase
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var expensesViews: [ServiceViewData] = []


    var groupedCosts: [String: [ServiceViewData]] {
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
    
    @Published var saveExpenseNetworkResult: NetworkResult<String> = .idle
    @Published var getExpensesNetworkResult: NetworkResult<[String: [ExpensePresentation]]> = .idle
    
    @Published var showAlertDialog = false
    @Published var dialogMessage = ""
    @Published var isSaved = false
    @Published var categories: [CategoryViewData] = []
    @Published var companies: [CompanyViewData] = []

    
    
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
    
    func update(
        id: String,
        title: String,
        description: String,
        amount: Double,
        expenseCategoryId: String,
        companyId: String,
        date: Date
    ) {
        if let email = self.auth.currentUser?.email {
            let request = ServiceRequest(
                id: id,
                title: title,
                description: description,
                userEmail: email,
                amount: amount,
                categoryId: expenseCategoryId,
                companyId: companyId,
                date: date
            )
            
           
            self.editServiceUseCase.execute(request: request)
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
    
    func getServices(startDate: Date, endDate: Date) {
        if let email = self.auth.currentUser?.email {
            self.getAllServiceUseCase.execute(userEmail: email, startDate: startDate, endDate: endDate)
                .subscribe(on: DispatchQueue.global())
                .receive(on: DispatchQueue.main)
                .map {
                    $0.map { item in
                        ServiceViewData(id: item.id,
                                        title: item.title,
                                        description: item.description,
                                        userEmail: item.userEmail,
                                        amount: item.amount,
                                        date: item.date,
                                        expenseCategory: CategoryViewData(
                                            id: item.category.id,
                                            name: item.category.name)
                                        ,
                                        company: CompanyViewData(
                                            id: item.company.id,
                                            address: item.company.address,
                                            contactNumber: item.company.contactNumber,
                                            name: item.company.name,
                                            userEmail: item.userEmail)
                        )
                    }
                }
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        break
                    case .finished:
                        break
                    }
                } receiveValue: { servicesViewData in
                    self.expensesViews = servicesViewData
                }
                .store(in: &cancellables)
        }
    }
    
    func remove(at position: Int, from date: String) {
        
        let itemToDelte = groupedCosts[date]![position]
            
            deleteServiceUseCase.execute(id: itemToDelte.id)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.showAlertDialog = true
                    self.dialogMessage = error.localizedDescription
                case .finished:
                    break
                }
                
            } receiveValue: { _ in
                
            }
            .store(in: &cancellables)

    }
    
    
}
