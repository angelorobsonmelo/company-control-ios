//
//  CompanyViewModel.swift
//  companycontrol
//
//  Created by Ângelo Melo on 07/06/2023.
//

import Foundation
import Firebase
import Combine

class CompanyViewModel: ObservableObject {
    
    @Published var getCompaniesNetworkResult: NetworkResult<[CompanyViewData]> = .idle
    @Published var saveNetworkResult: NetworkResult<String> = .idle
    @Published var networkResult: NetworkResult<String> = .idle
    @Published var loadingState = LoadingState<[CompanyViewData]>.idle
    @Published var showAlertDialog = false
    @Published var dialogMessage = ""
    @Published var isCompanySaved = false

    
    private var cancellables: Set<AnyCancellable> = []
    
    private let saveCompanyUseCase: SaveCompanyUseCase
    private let deleteCompanyUseCase: DeleteCompanyUseCase
    private let updateCompanyUseCase: UpdateCompanyUseCase
    private let getCompaniesUseCase: GetCompaniesUseCase
    private let auth: Auth
    
    
    init(saveCompanyUseCase: SaveCompanyUseCase,
         deleteCompanyUseCase: DeleteCompanyUseCase,
         updateCompanyUseCase: UpdateCompanyUseCase,
         getCompaniesUseCase: GetCompaniesUseCase,
         auth: Auth) {
        self.saveCompanyUseCase = saveCompanyUseCase
        self.deleteCompanyUseCase = deleteCompanyUseCase
        self.updateCompanyUseCase = updateCompanyUseCase
        self.getCompaniesUseCase = getCompaniesUseCase
        self.auth = auth
    }
    
    
    func getCompanies() {
        if let email = self.auth.currentUser?.email {
            self.loadingState = .loading
            
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
                        self.loadingState = .failed(error)
                        
                    case .finished:
                        break
                    }
                } receiveValue: { companyViewData in
                    self.loadingState = .succeeded(companyViewData)
                }
                .store(in: &cancellables)
        }
    }
    
    func save(
        name: String,
        address: String,
        contactNumber: String
    ) {
        saveNetworkResult = .loading
        if let email = self.auth.currentUser?.email {
            let id = Utils.generateCustomID()
            let request = CompanyRequest(
                id: id,
                address: address,
                contactNumber: contactNumber,
                name: name,
                userEmail: email
            )
            
            self.saveCompanyUseCase.execute(request: request)
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
                            default:
                                print("Unhandled validation error")
                            }
                        default:
                            print("Unknown error: \(error)")
                        }
                        
                    case .finished:
                        self.showAlertDialog = true
                        self.dialogMessage = "Save Successfully"
                        self.isCompanySaved = true
                    }
                } receiveValue: { _ in
                
                }
                .store(in: &cancellables)
        }
    }
    
    func remove(id: String) {
        deleteCompanyUseCase.execute(id: id)
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
    
    func update(
        id: String,
        name: String,
        address: String,
        contactNumber: String
    ) {
        if let email = self.auth.currentUser?.email {
            let request = CompanyRequest(
                id: id,
                address: address,
                contactNumber: contactNumber,
                name: name,
                userEmail: email
            )
            
            self.updateCompanyUseCase.execute(request: request)
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
                            default:
                                print("Unhandled validation error")
                            }
                        default:
                            print("Unknown error: \(error)")
                        }
                        
                    case .finished:
                        self.showAlertDialog = true
                        self.dialogMessage = "Save Successfully"
                        self.isCompanySaved = true
                    }
                } receiveValue: { _ in
                
                }
                .store(in: &cancellables)
            
        }
        
    }
    
}
