//
//  AuthViewModel.swift
//  companycontrol
//
//  Created by Ângelo Melo on 12/05/2023.
//

import Foundation

class AuthViewModel: ObservableObject {
    
    @Published var networkResult: NetworkResult<Bool> = .idle
    
    private let authUseCase: AuthUseCase
    
    init(authUseCase: AuthUseCase) {
        self.authUseCase = authUseCase
    }
    
    func auth(email: String, password: String) {
        networkResult = .loading
        
        DispatchQueue.global().async {
            self.authUseCase.auth(email: email, password: password) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self.networkResult = .success(true)
                    case .failure(let error):
                        self.networkResult = .error(error.localizedDescription)
                    }
                }
            }
            
        }
        
    }
    
}
