//
//  AuthViewModel.swift
//  companycontrol
//
//  Created by Ângelo Melo on 12/05/2023.
//

import Foundation
import Combine

class AuthViewModel: ObservableObject {
    
    @Published var loginNetworkResult: NetworkResult<Bool> = .idle
    @Published var registerNetworkResult: NetworkResult<Bool> = .idle
    private var cancellables: Set<AnyCancellable> = []
    @Published var isSignOutSuccessfully = false


    
    private let authUseCase: AuthUseCase
    private let registerUseCase: RegisterUseCase
    private let signOutUseCase: SignOutUseCase
    
    init(
         authUseCase: AuthUseCase,
         registerUseCase: RegisterUseCase,
         signOutUseCase: SignOutUseCase
        ) {
        self.authUseCase = authUseCase
        self.registerUseCase = registerUseCase
        self.signOutUseCase = signOutUseCase
    }
    
    func auth(email: String, password: String) {
        loginNetworkResult = .loading
        
        DispatchQueue.global().async {
            self.authUseCase.auth(email: email, password: password) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self.loginNetworkResult = .success(true)
                    case .failure(let error):
                        self.loginNetworkResult = .error(error.localizedDescription, Date())
                    }
                }
            }
            
        }
    }
    
    func register(email: String, password: String) {
        registerNetworkResult = .loading
        
        DispatchQueue.global().async {
            self.registerUseCase.register(email: email, password: password) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self.registerNetworkResult = .success(true)
                    case .failure(let error):
                        self.registerNetworkResult = .error(error.localizedDescription, Date())
                    }
                }
            }
            
        }
    }
    
    func signOut() {
        signOutUseCase.execute()
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.isSignOutSuccessfully = false
                   break
                case .finished:
                    self.isSignOutSuccessfully = true
                    break
                }
                
            } receiveValue: { _ in
                
            }
            .store(in: &cancellables)
    }
    
}
