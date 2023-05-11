//
//  ExpenseViewModel.swift
//  companycontrol
//
//  Created by Ângelo Melo on 11/05/2023.
//

import Foundation

class ExpenseViewModel: ObservableObject {
    
    @Published var networkResult: NetworkResult<User> = .idle

    private let getExpensesUseCase: GetExpensesUseCase
    
    init(getExpensesUseCase: GetExpensesUseCase) {
        self.getExpensesUseCase = getExpensesUseCase
    }
    
    func getExpenses() {
        DispatchQueue.global().async {
            
            self.getExpensesUseCase.test()
            
        }
    }
    
    func fetchData() {
            networkResult = .loading // Define o estado de loading
            
            DispatchQueue.global().async {
                // Simulando uma requisição com atraso
                sleep(2)
                
                DispatchQueue.main.async {
                    if Bool.random() {
                        // Simulando uma resposta bem-sucedida
                        self.networkResult = .success(User(name: "John Doe", email: "john@example.com"))
                    } else {
                        // Simulando uma resposta com erro
                        self.networkResult = .error("Erro na requisição")
                    }
                }
            }
        }
    
}
