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
                        print(error)
                        
                    case .finished:
                        break
                    }
                } receiveValue: { _ in
                    
                }
                .store(in: &cancellables)
            
            
        }
    }
    
    func remove(id: String) {
        networkResult = .loading
        
        DispatchQueue.global().async {
            self.deleteCompanyUseCase.delete(id: id) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self.networkResult = .success(Utils.generateCustomID())
                    case .failure(let error):
                        self.networkResult = .error(error.localizedDescription, Date())
                    }
                }
            }
        }
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
            
            DispatchQueue.global().async {
                self.updateCompanyUseCase.update(request: request) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success:
                            self.networkResult = .success(Utils.generateCustomID())
                        case .failure(let error):
                            self.networkResult = .error(error.localizedDescription, Date())
                        }
                    }
                }
            }
            
        }
        
    }
    
}
