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
    private let auth: Auth
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var showAlertDialog = false
    @Published var dialogMessage = ""
    @Published var isSaved = false

    
    init(saveUseCase: SaveServiceUseCase, auth: Auth) {
        self.saveUseCase = saveUseCase
        self.auth = auth
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
    
    
}
