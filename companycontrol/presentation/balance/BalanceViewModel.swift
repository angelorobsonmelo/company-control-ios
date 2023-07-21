//
//  BalanceViewModel.swift
//  companycontrol
//
//  Created by Ângelo Melo on 21/07/2023.
//

import Foundation
import Combine
import Firebase

class BalanceViewModel: ObservableObject {
    
    
    private let getBalanceUseCase: GetBalanceUseCase
    private let auth: Auth
    
    init(getBalanceUseCase: GetBalanceUseCase, auth: Auth) {
        self.getBalanceUseCase = getBalanceUseCase
        self.auth = auth
    }

    
    @Published var balanceViews: BalanceViewData?
    private var cancellables: Set<AnyCancellable> = []

    func getBalance(startDate: Date, endDate: Date) {
        if let email = self.auth.currentUser?.email {
            self.getBalanceUseCase.execute(userEmail: email, startDate: startDate, endDate: endDate)
                .subscribe(on: DispatchQueue.global())
                .receive(on: DispatchQueue.main)
                .map { result in
                    let totalExpenses = result.expenses.reduce(0, { $0 + $1.amount })
                    let totalServices = result.services.reduce(0, { $0 + $1.amount })
                    let total = totalExpenses + totalServices
                    
                    return BalanceViewData(
                        total: total,
                        totalExpenses: totalExpenses,
                        totalServices: totalServices)
                }
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error: \(error)")
                    case .finished:
                        print("Finished")
                    }
                } receiveValue: { balanceViewData in
                    self.balanceViews = balanceViewData
                }
                .store(in: &cancellables)
        }
    }

   
    
}
