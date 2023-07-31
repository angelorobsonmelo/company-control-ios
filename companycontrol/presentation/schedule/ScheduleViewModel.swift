//
//  ScheduleViewModel.swift
//  companycontrol
//
//  Created by Ângelo Melo on 31/07/2023.
//

import Foundation
import Combine
import Firebase

class ScheduleViewModel: ObservableObject {
    
    private let auth: Auth
    private let saveScheduleUseCase: SaveScheduleUseCase
    
    init(auth: Auth, saveScheduleUseCase: SaveScheduleUseCase) {
        self.auth = auth
        self.saveScheduleUseCase = saveScheduleUseCase
    }
    
    private var cancellables: Set<AnyCancellable> = []
    @Published var showAlertDialog = false
    @Published var dialogMessage = ""
    @Published var isSaved = false
    
    func save(
        title: String,
        description: String,
        date: Date,
        completed: Bool
    ) {
        if let email = self.auth.currentUser?.email {
            let request = ScheduleRequest(
                id: Utils.generateCustomID(),
                title: title,
                description: description,
                date: date,
                userEmail: email,
                completed: completed)
            
           
            self.saveScheduleUseCase.execute(request: request)
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
